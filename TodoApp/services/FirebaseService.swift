//
//  FirebaseHandler.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class FirebaseService {
    

    static let shared = FirebaseService()
    lazy var dbRef: DatabaseReference = {
        Database.database(url: "https://todoapp-c5829-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }()
    
    private init()  {
//        if let user = current {
//            try? Auth.auth().signOut()
//        }
    }
    
    var current: User? {
        Auth.auth().currentUser
    }
    
    func storeUserName(value: String, userId: String) async throws {
        try await dbRef.child("users")
            .child(userId)
            .setValue(["username": value])
    }
    
    func fetch(userId: String) async throws -> String? {
        let snapshot = try await dbRef.child("users/\(userId)/username")
            .getData()
        return snapshot.value as? String 
    }
    
    func checkUser() async throws -> InternalUser? {
        guard let user = self.current else {
            return nil
        }
        guard let userName = try await fetch(userId: user.uid) else {
            return nil
        }
        return InternalUser.from(firebaseUser: user, username: userName)
    }
    
    func loginWithUsername(value: String) async throws -> InternalUser {
        let result = try await Auth.auth().signInAnonymously()
        try await dbRef.child("users")
            .child(result.user.uid)
            .setValue(["username": value])
        return InternalUser.from(firebaseUser: result.user, username: value)
    }

    func addNewNote(value: String) async throws {
        guard let uid = self.current?.uid else {
            throw UnAuthenError()
        }
        let dict = [
            "content": value,
            "creationTime": Date().timeIntervalSince1970,
            "lastupdateTime": Date().timeIntervalSince1970
        ] as [String : Any]
        let newItemRef = dbRef.child("users/\(uid)/notes").childByAutoId()
        try await newItemRef.setValue(dict)
    }
    
    func loadNotes(
        onNewData: @escaping ([Note]) -> Void,
        onDeleteData: @escaping ([Note]) -> Void
    ) throws {
        guard let uid = self.current?.uid else {
            throw UnAuthenError()
        }
        dbRef.child("users/\(uid)/notes").observe(DataEventType.childAdded) { snapShot in
            if let note = Note.fromDataSnapShot(snapShot: snapShot) {
                onNewData([note])
            }
        }
        dbRef.child("users/\(uid)/notes").observe(DataEventType.childRemoved) { snapShot in
            if let note = Note.fromDataSnapShot(snapShot: snapShot) {
                onDeleteData([note])
            }
        }
    }
    
    func deleteNotes(value: Note) async throws {
        guard let uid = self.current?.uid else {
            throw UnAuthenError()
        }
        try await dbRef.child("users/\(uid)/notes/\(value.id)").removeValue()
    }
    
    func findFriend(value: String) async throws {
        let result = try await dbRef.child("users").queryOrdered(byChild: "username")
            .queryEqual(toValue: value)
            .observeSingleEventAndPreviousSiblingKey(of: DataEventType.value)
    
        
//        print(result)
    }
}

extension String {
    func toDate() -> Date? {
        // Convert the string to a Double
        guard let timestamp = Double(self) else {
            return nil
        }
        
        // Convert milliseconds to seconds if the timestamp is in milliseconds
        let seconds = timestamp > 1_000_000_000_000 ? timestamp / 1000 : timestamp
        
        // Convert the timestamp to a Date object
        return Date(timeIntervalSince1970: seconds)
    }
}
