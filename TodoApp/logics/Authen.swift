//
//  Authen.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import Combine

@MainActor
class Authen: ObservableObject {
    @Published var state: AuthenState = .initial
    var firebase: FirebaseService {  FirebaseService.shared }
    
    var userData: InternalUser? {
        switch state {
        case .success(let user):
            return user
        default:
            return nil
        }
    }
    
    func loadData() async {
        do {
            if let result = try await firebase.checkUser() {
                state = .success(result)
                return
            }
        } catch let err {
            print(err)
        }
        state = .initial
    }
    
    func login(userName: String) async throws {
        if userName.isEmpty {
            throw UsernameValidateError(message: "")
        }
        let loginResult = try await firebase.loginWithUsername(value: userName)
        state = .success(loginResult)
    }
}
