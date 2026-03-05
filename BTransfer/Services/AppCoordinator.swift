//
//  AppCoordinator.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var sheet: AppRoute?
    @Published var fullScreenCover: AppRoute?

    init() {}
}

extension AppCoordinator {

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func presentSheet(_ route: AppRoute) {
        sheet = route
    }

    func presentFullScreenCover(_ route: AppRoute) {
        fullScreenCover = route
    }

    func dismissSheet() {
        sheet = nil
    }

    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
}
