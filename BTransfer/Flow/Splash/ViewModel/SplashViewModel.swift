//
//  SplashViewModel.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    let provider: AppProvider
    @Binding var showMain: Bool
    
    @Published var animationState: AnimationState = .idle
    @Published var pulseAnimation = false
    @Published var rotationAnimation = false
    
    init(provider: AppProvider, showMain: Binding<Bool>) {
        _showMain = showMain
        self.provider = provider
    }
    
    func startAnimation() {
        animationState = .animating
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.animationState = .completed
            self?.navigateToFinder()
        }
    }
    
    private func navigateToFinder() {
        showMain = true
    }
    
    func turnOnAnimations() {
        withAnimation {
            pulseAnimation = true
            rotationAnimation = true
        }
    }
}
