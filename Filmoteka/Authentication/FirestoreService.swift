//
//  FirestoreService.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 13.06.2023.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    static let db = Firestore.firestore()
    
    class func saveUserUID(_ uid: String) {
        let userRef = db.collection("users").document(uid)
        
        userRef.setData(["uid": uid]) { error in
            if let error = error {
                print("Error saving user UID to Firestore: \(error.localizedDescription)")
            } else {
                print("User UID saved to Firestore")
            }
        }
    } 
 }

