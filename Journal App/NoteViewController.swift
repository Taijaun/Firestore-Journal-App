//
//  NoteViewController.swift
//  Journal App
//
//  Created by Taijaun Pitt on 16/03/2023.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var note: Note?
    var notesModel: NotesModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
        }

        
    }

    
    @IBAction func deleteTapped(_ sender: Any) {
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    

}
