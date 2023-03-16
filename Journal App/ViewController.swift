//
//  ViewController.swift
//  Journal App
//
//  Created by Taijaun Pitt on 16/03/2023.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    private var notesModel = NotesModel()
    private var notes = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set delegate and datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set delf as the delegate for the ntoes model
        notesModel.delegate = self
        
        // Retrieve all notes
        notesModel.getNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let noteViewController = segue.destination as! NoteViewController
        
        // If the user selected a row, transition to notes vc
        if tableView.indexPathForSelectedRow != nil {
            
            // Set the note and notes model properties of the note vc
            noteViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            noteViewController.notesModel = self.notesModel
        }
        
    }
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        // TODO: Customise cell
        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body
        
        return cell
        
    }
    
}

extension ViewController: NotesModelProtocol {
    
    func noteRetrieved(notes: [Note]) {
        
        // Set notes property and refresh the table view
        self.notes = notes
        
        tableView.reloadData()
    }
    

    
}
