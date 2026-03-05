//
//  SplashView.swift
//  BTransfer
//
//  Created by Behruz Norov on 04/03/26.
//

import SwiftUI
import CoreData

struct SplashView: View {
    @StateObject private var vm: SplashViewModel
    
    init(provider: AppProvider) {
        _vm = StateObject(wrappedValue: SplashViewModel(provider: provider))
    }
    
    var body: some View {
        ZStack {
            
        }
    }
}

#Preview {
    SplashView(provider: AppProvider())
}
