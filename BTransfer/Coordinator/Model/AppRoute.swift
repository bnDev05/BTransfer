//
//  AppRoute.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

enum AppRoute: Hashable, Identifiable {
    case finder
    case transfer
    case success
    
    var id: String {
        switch self {
        case .finder:
            return "finder"
        case .transfer:
            return "transfer"
        case .success:
            return "success"
        }
    }
}
