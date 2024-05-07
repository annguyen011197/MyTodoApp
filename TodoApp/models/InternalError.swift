//
//  InternalError.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation

protocol InternalError: Error {
    var message: String { get }
}


struct FirebaseAuthenError: InternalError {
    var error: Error
    var message: String = ""
}

struct UsernameValidateError: InternalError {
    var message: String
}

struct NewNoteEmptyError: InternalError {
    var message: String = ""
}

struct UnAuthenError: InternalError {
    var message: String = "UnAuthenError"
}

struct CustomError: InternalError {
    var message: String = "Error"
}
