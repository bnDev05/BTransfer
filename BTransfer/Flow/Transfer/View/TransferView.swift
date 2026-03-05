//
//  TransferView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct TransferView: View {
    @StateObject private var vm: TransferViewModel
    @FocusState private var amountFocused: Bool

    init(provider: AppProvider, info: UserInfo) {
        _vm = StateObject(wrappedValue: TransferViewModel(userData: info, provider: provider))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                cardsSection
                    .padding(.top, 24)

                Spacer().frame(height: 32)

                amountSection

                Spacer().frame(height: 32)

                transferButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden()
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Transfer")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onTapGesture { amountFocused = false }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
    }
    
    private var backButton: some View {
        Button {
            vm.coordinator.pop()
        } label: {
            Image(systemName: "chevron.left")
        }

    }

    private var cardsSection: some View {
        VStack {
            CardView(
                label: "From",
                name: vm.senderName,
                maskedCard: vm.senderMaskedCard
            )

            CardView(
                label: "To",
                name: vm.receiverName,
                maskedCard: vm.receiverMaskedCard
            )
        }
    }


    private var amountSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amount")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            HStack(spacing: 8) {
                Text("$")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.secondary)

                TextField("0.00", text: $vm.amount)
                    .font(.title2.weight(.semibold))
                    .keyboardType(.decimalPad)
                    .focused($amountFocused)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var transferButton: some View {
        Button {
            vm.transfer()
        } label: {
            Text("Transfer")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
