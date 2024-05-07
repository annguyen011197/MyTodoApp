//
//  NoteView.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

struct NoteView: View {
    @EnvironmentObject var notes: Notes
    @State var isShowError: Bool = false
    @ObservedObject private var noteView = DeleteNote()
    var item: Note
    var body: some View {
        HStack(content: {
            Text(item.content)
            Spacer()
            switch noteView.deleteNoteState {
            case .initialLoading:
                ProgressView().progressViewStyle(.circular)
            default:
                Button(action: {
                        noteView.deleteData(note: item)
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
            }

        })
        .padding(.all, 24)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.blue, lineWidth: 4)
        }
        .padding(.all, 2)
        .onReceive(noteView.$deleteNoteState, perform: { state in
            switch state {
            case .failure(let err):
                isShowError.toggle()
            default:
                break
            }
        })
        .alert(isPresented: $isShowError, content: {
            Alert(title: Text("Error"), dismissButton: .default(Text("OK"), action: {
                isShowError = false
                noteView.resetDeleteState()
            }))
        })
    }
}
