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
    
    @Published var animationState: AnimationState = .idle
    @Published var pulseAnimation = false
    @Published var rotationAnimation = false
    
    init(provider: AppProvider) {
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
        provider.coordinator.push(.finder)
    }
    
    func turnOnAnimations() {
        withAnimation {
            pulseAnimation = true
            rotationAnimation = true
        }
    }
}
