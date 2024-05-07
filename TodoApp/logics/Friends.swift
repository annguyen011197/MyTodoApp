//
//  Friends.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

@MainActor
class Friends: ObservableObject {
//    @Published var currentNotes: [Note] = []

    
    func shareToFriend(value: String) {
        Task.init {
            do {
                try await FirebaseService.shared.findFriend(value: value)
            } catch let err {
                print(err)
            }
        }
    }
}
    
