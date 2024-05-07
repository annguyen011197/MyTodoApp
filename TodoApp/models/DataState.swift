//
//  DataState.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation

enum DataState<V, E: Error> {
    case idle
    case initialLoading
    case success (V)
    case failure(E)
    
    var isIdle: Bool {
        switch self {
        case .idle:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .initialLoading:
            return true
        default:
            return false
        }
    }
}
