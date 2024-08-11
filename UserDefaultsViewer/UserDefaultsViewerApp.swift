//
//  UserDefaultsViewerApp.swift
//  UserDefaultsViewer
//
//  Created by aram on 8/11/24.
//

import SwiftUI

@main
struct UserDefaultsViewerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
