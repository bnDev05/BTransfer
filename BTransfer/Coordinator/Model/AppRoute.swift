//
//  AppRoute.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

enum AppRoute: Hashable, Identifiable {
    case finder
    case transfer(userData: UserInfo)
    case cards(vm: BFinderViewModel)
    case success(userData: UserInfo)
    
    var id: String {
        switch self {
        case .finder:
            return "finder"
        case .transfer(_):
            return "transfer"
        case .cards(_):
            return "cards"
        case .success(_):
            return "success"
        }
    }
}
