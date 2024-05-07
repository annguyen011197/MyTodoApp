//
//  Note.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import FirebaseDatabase

struct Note: Identifiable {
    let id: String
    let content: String
    let creationTime: Date
    let updateTime: Date
    
    static func fromDataSnapShot(snapShot: DataSnapshot) -> Note? {
        if let dict = snapShot.value as? [String: Any] {
            let note  = Note(
                id: snapShot.key,
                content: (dict["content"] as? String) ?? "",
                creationTime: (dict["creationTime"] as? String)?.toDate() ?? Date(),
                updateTime: (dict["lastupdateTime"] as? String)?.toDate() ?? Date()
            )
            return note
        }
        return nil
    }
}
