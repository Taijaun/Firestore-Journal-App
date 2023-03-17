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
        
        if self.note != nil {
            notesModel?.deleteNote(self.note!)
        }
        
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if self.note == nil {
            // This is a brand new note
            
            // Create the note
            let n = Note(docId: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
            
            self.note = n
        } else {
            // This is an update to the existing note
            self.note?.title = titleTextField.text ?? ""
            self.note?.body = bodyTextView.text ?? ""
            self.note?.lastUpdatedAt = Date()
        }
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
    }
    
    

}
