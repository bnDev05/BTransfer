//
//  CoordinatorView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator
    private let provider: AppProvider
    init(provider: AppProvider) {
        self.provider = provider
        self._coordinator = StateObject(
            wrappedValue: provider.coordinator
        )
    }
    var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.path) {
                SplashView(provider: provider)
                    .navigationDestination(for: AppRoute.self) { route in
                        view(for: route)
                            .navigationBarBackButtonHidden()
                    }
            }
            .sheet(item: $coordinator.sheet) { route in
                view(for: route)
            }
            .zIndex(0)
            
            if let route = coordinator.fullScreenCover {
                view(for: route)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 1.1)),
                        removal: .opacity
                    ))
                    .zIndex(1)
                    .onTapGesture {}
            }
        }
        .animation(.easeInOut, value: coordinator.fullScreenCover?.id)
        .environmentObject(coordinator)
    }
    
    @ViewBuilder
    private func view(for route: AppRoute) -> some View {
        switch route {
        case .finder:
            BFinderView(provider: provider)
        case .transfer:
            EmptyView()
        case .success:
            EmptyView()
        }
    }
}

#Preview {
    CoordinatorView(provider: AppProvider())
}
