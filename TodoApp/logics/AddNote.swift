//
//  AddNote.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import Combine

@MainActor
class AddNote: ObservableObject {
    @Published var note: String = ""
    @Published var addNoteState: DataState<Bool, Error>  = .idle
    @Published var isLoading: Bool = false
    var firebase: FirebaseService {  FirebaseService.shared }
    var cancellables = Set<AnyCancellable>()
    
    init() {    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func reset() {
        addNoteState = .idle
    }
    
    func addNewNote() {
        if note.isEmpty {
            addNoteState = .failure(NewNoteEmptyError())
            return
        }
        addNoteState = .initialLoading
        Task.init {
            do {
                try await firebase.addNewNote(value: note)
                addNoteState = .success(true)
            } catch let err {
                addNoteState = .failure(err)
            }
        }
    }
}
