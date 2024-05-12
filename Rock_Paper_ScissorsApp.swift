//
//  Rock_Paper_ScissorsApp.swift
//  Rock Paper Scissors
//
//  Created by Vincent Leong on 12/5/2024.
//

import SwiftUI
import SwiftData

@main
struct Rock_Paper_ScissorsApp: App {
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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
