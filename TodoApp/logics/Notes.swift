//
//  Notes.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
//
@MainActor
class Notes: ObservableObject {
    @Published var currentNotes: [Note] = []
    
    func fetchData() {
        try? FirebaseService.shared.loadNotes(onNewData: { [weak self] notes in
            self?.currentNotes += notes
        }, onDeleteData: { [weak self] notes in
            guard let self = self else { return }
            self.currentNotes.removeAll { value in
                notes.contains { note in
                    value.id == note.id
                }
            }
        })
    }
}
    
