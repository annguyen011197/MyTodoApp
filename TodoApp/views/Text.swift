//
//  Text.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import SwiftUI

struct ErrorText: View  {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.red)
    }
}
