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
    var listener: ListenerRegistration?
    
    deinit {
        // unregister database listener
        listener?.remove()
    }
    
    func getNotes(_ starredOnly: Bool = false) {
        
        // Detach any listener
        listener?.remove()
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        var query: Query = db.collection("notes")
        
        // If we're only looking for starred notes, update the query
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        // get all the notes
        self.listener = query.addSnapshotListener({ snapshot, error in
            
            // Check for errors
            if error == nil && snapshot != nil {
                
                var notes = [Note]()
                
                // Parse documents into notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    let lastUpdatedAtDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)()
                    let docId = doc["docId"] as! String
                    
                    
                    let n = Note(docId: docId, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate, lastUpdatedAt: lastUpdatedAtDate)
                    
                    notes.append(n)
                    
                }
                
                // Call the delegate and pass back the notes in the main thread
                DispatchQueue.main.async {
                    self.delegate?.noteRetrieved(notes: notes)
                }
                
                
            }
        })
        
    }
    
    func deleteNote(_ n: Note) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).delete()
        
    }
    
    func saveNote(_ n:Note) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).setData(noteToDict(n))
    }
    
    func updateFaveStatus(_ docId: String, isStarred: Bool) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(docId).updateData(["isStarred":isStarred])
    }
    
    func noteToDict(_ n: Note) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["docId"] = n.docId
        dict["title"] = n.title
        dict["body"] = n.body
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        dict["isStarred"] = n.isStarred
        
        return dict
    }
    
}
