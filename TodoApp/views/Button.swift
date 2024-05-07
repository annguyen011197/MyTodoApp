//
//  Button.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import Foundation
import SwiftUI

struct AppButton: View {
    var title: String
    var action: () -> Void 
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .foregroundStyle(.white)
        }.background(Color.accentColor)
            .clipShape(.buttonBorder)
    }
}
