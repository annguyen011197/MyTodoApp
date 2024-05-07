//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by An Nguyen on 06/05/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct TodoAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var authen = Authen()
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .environmentObject(authen)
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        setupFirebase()
    }
}

fileprivate extension TodoAppApp {
    func setupFirebase() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
}
