//
//  AddNoteBottomSheet.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

struct AddNoteBottomSheet: View {
    @StateObject private var model: AddNote = AddNote()
    @Binding var isShowingInput: Bool
    
    var body: some View {
        VStack(alignment: .leading, content: {
            HStack(content: {
                TextField(text: $model.note) {
                    Text("New note")
                }
                    .disabled(model.addNoteState.isLoading)
                    .onTapGesture {
                        model.reset()
                    }
                button
            })
            if case let DataState.failure(err) = model.addNoteState {
                ErrorText(text: {
                    if err is NewNoteEmptyError {
                        return "Your Note is empty"
                    }
                    return "Error happen, Please try again"
                }())
            }
        })
            .padding(.all, 24)
            .onReceive(model.$addNoteState, perform: { state in
                switch state {
                case .success(_):
                    isShowingInput = false
                default:
                    break
                }
            })
    }
    
    @ViewBuilder
    var button: some View {
        switch model.addNoteState {
        case .idle:
            Button(action: {
                model.addNewNote()
            }, label: {
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            })
        case .initialLoading:
            ProgressView().progressViewStyle(.circular)
        case .success, .failure:
            EmptyView()
        }
    }
}
#Preview {
    AddNoteBottomSheet()
}
