//
//  ScenePhase.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

enum ScanPhase: Equatable {
    case scanning(secondsLeft: Int)
    case finished
    case noResults
}
