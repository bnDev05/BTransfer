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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private var provider: AppProvider {
        appDelegate.provider
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(provider: provider)
        }
    }
}
