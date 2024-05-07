//
//  AuthenState.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation

enum AuthenState {
    case initial
    case success(InternalUser)
}
