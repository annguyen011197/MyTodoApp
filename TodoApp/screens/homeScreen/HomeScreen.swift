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
            .padding(.all, 32)
            .sheet(isPresented: $isShowingInput, content: {
                AddNoteBottomSheet(isShowingInput: $isShowingInput)
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


extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
