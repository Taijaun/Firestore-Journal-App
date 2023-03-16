//
//  NotesModel.swift
//  Journal App
//
//  Created by Taijaun Pitt on 16/03/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseCore


protocol NotesModelProtocol {
    
    func noteRetrieved(notes:[Note])
    
}

class NotesModel {
    
    var delegate: NotesModelProtocol?
    
    func getNotes() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // get all the notes
        db.collection("notes").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil && snapshot != nil {
                
                var notes = [Note]()
                
                // Parse documents into notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    let lastUpdatedAtDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)()
                    
                    
                    let n = Note(docId: doc["docId"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate, lastUpdatedAt: lastUpdatedAtDate)
                    
                    notes.append(n)
                    
                }
                
                // Call the delegate and pass back the notes in the main thread
                DispatchQueue.main.async {
                    self.delegate?.noteRetrieved(notes: notes)
                }
                
                
            }
            
        }
        
    }
    
}
