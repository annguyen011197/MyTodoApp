//
//  DeleteNote.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation

@MainActor
class DeleteNote: ObservableObject {
    @Published var deleteNoteState: DataState<Bool, Error> = .idle
    
    func deleteData(note: Note) {
        deleteNoteState = .initialLoading
        Task.init {
            do {
                try await FirebaseService.shared.deleteNotes(value: note)
                deleteNoteState = .success(true)
            } catch let err {
                deleteNoteState = .failure(err)
            }
        }
    }
    
    func resetDeleteState() {
        deleteNoteState = .idle
    }
}
