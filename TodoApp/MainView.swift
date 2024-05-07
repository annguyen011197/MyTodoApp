//
//  MainView.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var authen: Authen
    @State var isLoading: Bool = false
    @State var isChecked: Bool = false

    
    var body: some View {
        switch authen.state {
        case .initial:
            if isLoading {
                ProgressView().progressViewStyle(.circular)
            } else {
                AuthenScreen().onAppear(perform: {
                    loadData()
                })
            }
        case .success(let internalUser):
            HomeScreen().environmentObject(Notes())
        }
    }
    
    func loadData() {
        guard !isChecked else { return }
        isChecked = true
        Task.init {
            isLoading = true
            await authen.loadData()
            isLoading = false
        }
    }
}

#Preview {
    MainView()
}
