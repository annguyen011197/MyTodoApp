//
//  HomeScreen.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import SwiftUI
import Combine

struct HomeScreen: View {
    @EnvironmentObject var authen: Authen
    @EnvironmentObject var notes: Notes
    
    @State private var isShowingInput: Bool = false
    @State private var addNewText: String = ""
    
    var body: some View {
        NavigationView(content: {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 24, content: {
                title
                HomeScreenBody()
                AppButton(title: "Add new", action: {
                    isShowingInput.toggle()
                })
                Spacer()
                
            })
            .toolbar(content: {
                ToolbarItemGroup {
                    NavigationLink(destination: FriendScreen()) {
                        Text("Friends")
                    }
                }
            })
            .padding(.all, 32)
            .sheet(isPresented: $isShowingInput, content: {
                BottomSheet(isShowingInput: $isShowingInput)
                    .presentationDetents([.height(120)])
            })
            .onAppear(perform: {
                notes.fetchData()
            })
        })
        
    }
    
    @ViewBuilder
    var title: some View {
        if notes.currentNotes.isEmpty {
            Text("Hello \(authen.userData?.userName ?? ""), Let add your first note")
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            Text("Hello \(authen.userData?.userName ?? ""), Here are your notes: ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct HomeScreenBody: View {
    @EnvironmentObject var notes: Notes
    
    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(notes.currentNotes, id: \.id) { item in
                    NoteView(item: item)
                }
            })
        }
    }
}

@MainActor
class NoteViewModel: ObservableObject {
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

struct NoteView: View {
    @EnvironmentObject var notes: Notes
    @State var isShowError: Bool = false
    @ObservedObject private var noteView = NoteViewModel()
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

#Preview {
    HomeScreen().environmentObject(Authen())
}

struct BottomSheet: View {
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

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
