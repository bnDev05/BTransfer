//
//  BFinderView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct BFinderView: View {
    @StateObject private var vm: BFinderViewModel
    
    init(provider: AppProvider) {
        _vm = StateObject(wrappedValue: BFinderViewModel(provider: provider))
    }
    
    var body: some View {
        ZStack {
            
        }
    }
}

#Preview {
    BFinderView(provider: AppProvider())
}
