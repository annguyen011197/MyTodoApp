//
//  FriendScreen.swift
//  TodoApp
//
//  Created by An Nguyen on 07/05/2024.
//

import SwiftUI

struct FriendScreen: View {
    @State private var friendUserName: String = ""
    @StateObject private var friends: Friends = Friends()
    var body: some View {
        VStack(content: {
            HStack(content: {
                TextField("Your friend's username", text: $friendUserName)
                    .textFieldStyle(.roundedBorder)
                Button(action: {
                    friends.shareToFriend(value: friendUserName)
                }, label: {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                })
            })
            Spacer()
        })
        .padding(.all, 24)
    }
}

#Preview {
    FriendScreen()
}
