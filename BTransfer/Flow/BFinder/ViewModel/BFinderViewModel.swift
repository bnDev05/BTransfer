//
//  BFinderViewModel.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

final class BFinderViewModel: ObservableObject {
    let provider: AppProvider
    
    init(provider: AppProvider) {
        self.provider = provider
    }
}
