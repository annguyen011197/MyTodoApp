//
//  InternalUser.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import FirebaseAuth


struct InternalUser {
    var isAnonymous: Bool
    var uid: String
    var userName: String
    
    init(isAnonymous: Bool, uid: String, username: String) {
        self.isAnonymous = isAnonymous
        self.uid = uid
        self.userName = username
    }
    
    
    static func from(firebaseUser: User, username: String) -> InternalUser {
        var user = InternalUser(isAnonymous: firebaseUser.isAnonymous, uid: firebaseUser.uid, username: username)
        return user
    }
}

