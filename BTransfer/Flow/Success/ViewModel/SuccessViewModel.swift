//
//  SuccessViewModel.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

final class SuccessViewModel: ObservableObject {

    @Published private(set) var senderName: String
    @Published private(set) var senderMaskedCard: String
    @Published private(set) var receiverName: String
    @Published private(set) var receiverMaskedCard: String

    @Published var showCheckmark  = false
    @Published var showRipple     = false
    @Published var showSender     = false
    @Published var showArrow      = false
    @Published var showReceiver   = false
    @Published var showDoneButton = false

    let provider: AppProvider

    init(receiver: UserInfo, provider: AppProvider) {
        self.provider = provider

        let cardIndex = UserDefaults.standard.integer(forKey: String.cardIndex)
        let raw = Constants.cardNumbers[cardIndex]
            .replacingOccurrences(of: " ", with: "")

        self.senderName        = Constants.username
        self.senderMaskedCard  = "•••• •••• •••• \(String(raw.suffix(4)))"
        self.receiverName      = receiver.name
        self.receiverMaskedCard = "•••• •••• •••• \(receiver.lastFourCardNumber)"
    }

    func runAnimationSequence() {
        withAnimation {
            showCheckmark = true
        }

        after(0.3)  { self.showRipple = true }
        after(0.6)  { withAnimation { self.showSender = true } }
        after(0.85) { withAnimation { self.showArrow = true } }
        after(1.0)  { withAnimation { self.showReceiver = true } }
        after(1.4)  { withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            self.showDoneButton = true
        }}
    }

    func done() {
        provider.coordinator.popToRoot()
    }

    private func after(_ seconds: Double, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: block)
    }
}
