//
//  AppProvider.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

final class AppProvider {
    let services: AppServices
    let coordinator: AppCoordinator
    
    init() {
        self.services = AppServices()
        self.coordinator = AppCoordinator()
    }
}
