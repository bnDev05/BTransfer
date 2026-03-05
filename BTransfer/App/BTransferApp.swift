//
//  BTransferApp.swift
//  BTransfer
//
//  Created by Behruz Norov on 04/03/26.
//

import SwiftUI
import CoreData

@main
struct BTransferApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
