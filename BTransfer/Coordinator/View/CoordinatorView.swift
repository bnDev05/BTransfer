//
//  CoordinatorView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator
    @State private var showMain: Bool = false
    private let provider: AppProvider
    var onCardSelected: ((Int) -> Void)?

    init(provider: AppProvider) {
        self.provider = provider
        self._coordinator = StateObject(
            wrappedValue: provider.coordinator
        )
    }
    var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.path) {
                if showMain {
                    BFinderView(provider: provider)
                        .navigationDestination(for: AppRoute.self) { route in
                            view(for: route)
                        }
                } else {
                    SplashView(provider: provider, showMain: $showMain)
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
        case .transfer(let info):
            TransferView(provider: provider, info: info)
        case .cards(let vm):
            CardPickerSheet(vm: vm)
        case .success(let info):
            SuccessView(receiver: info, provider: provider)
        }
    }
}

#Preview {
    CoordinatorView(provider: AppProvider())
}
