//
//  CoreDataBootCampApp.swift
//  CoreDataBootCamp
//
//  Created by Миша Перевозчиков on 14.06.2022.
//

import SwiftUI

@main
struct CoreDataBootCampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
