//
//  AuthenScreen.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

struct AuthenScreen: View {
    @State var username: String = ""
    @State var isLoading: Bool = false
    @State var error: Error? = nil
    @EnvironmentObject private var authen: Authen

    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 24, content: {
            VStack(content: {
                Text("Hi, Welcome to TodoApp.")
                    .frame(alignment: .center)
                    .layoutPriority(1)
                Text("Please set your username:")
                    .frame( alignment: .center)
                    .layoutPriority(1)
            })
            userNameTextField
            loginButton
        })
        .padding(.all, 32)
    }
    
    @ViewBuilder
    var userNameTextField: some View {
        TextField(text: $username) {
            Text("Username")
        }
        .textFieldStyle(.roundedBorder)
        .frame(width: 200)
        
        if let error = self.error as? FirebaseAuthenError {
            ErrorText(text: "Username must not empty!")
        }
    }
    
    var basicLoginButton: some View {
        AppButton(title: "Get Started", action: performLogin)
    }
    
    @ViewBuilder
    var loginButton: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            if let error = self.error as? FirebaseAuthenError {
                ErrorText(text: "Error happen, Please try again")
            }
            basicLoginButton
        }
    }
    
    func performLogin() {
        Task {
            do {
                isLoading = true
                defer {
                    isLoading = false
                }
                try await authen.login(userName: username)
            } catch let err {
                self.error = err
            }
        }
    }
}

#Preview {
    AuthenScreen()
}
