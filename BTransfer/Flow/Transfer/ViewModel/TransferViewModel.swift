//
//  TransferViewModel.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

final class TransferViewModel: ObservableObject {
    @AppStorage(.cardIndex) private var selectedCardIndex = 0
    @Published var amount: String = ""
    let coordinator: AppCoordinator
    
    let senderName: String
    var senderMaskedCard: String {
        let senderRaw = Constants.cardNumbers[selectedCardIndex]
            .replacingOccurrences(of: " ", with: "")
        return "•••• •••• •••• \(String(senderRaw.suffix(4)))"
    }
    
    let receiverName: String
    let receiverMaskedCard: String
    let userData: UserInfo
    let provider: AppProvider
    
    init(userData: UserInfo, provider: AppProvider) {
        self.coordinator = provider.coordinator
        self.userData = userData
        self.provider = provider
        self.senderName = Constants.username
        self.receiverName = userData.name
        self.receiverMaskedCard = "•••• •••• •••• \(userData.lastFourCardNumber)"
    }
    
    func transfer() {
        coordinator.push(.success(userData: userData))
    }
}
