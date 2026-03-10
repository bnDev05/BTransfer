//
//  SuccessView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct SuccessView: View {
    @StateObject private var vm: SuccessViewModel

    init(receiver: UserInfo, provider: AppProvider) {
        _vm = StateObject(wrappedValue: SuccessViewModel(receiver: receiver, provider: provider))
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                checkmarkSection.padding(.bottom, 36)
                transferRoute.padding(.bottom, 48)
                Spacer()

                if vm.showDoneButton {
                    doneButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.runAnimationSequence() }
    }

    private var checkmarkSection: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(Color.green.opacity(vm.showRipple ? 0 : 0.25), lineWidth: 1.5)
                    .frame(width: vm.showRipple ? CGFloat(120 + i * 44) : 80)
                    .animation(
                        .easeOut(duration: 1.2)
                        .delay(Double(i) * 0.18)
                        .repeatForever(autoreverses: false),
                        value: vm.showRipple
                    )
            }

            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .scaleEffect(vm.showCheckmark ? 1 : 0.3)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: vm.showCheckmark)

            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .scaleEffect(vm.showCheckmark ? 1 : 0)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.55).delay(0.15),
                    value: vm.showCheckmark
                )
        }
        .frame(height: 160)
    }

    private var transferRoute: some View {
        HStack(alignment: .center, spacing: 0) {
            ParticipantCard(name: vm.senderName, maskedCard: vm.senderMaskedCard, isSender: true)
                .opacity(vm.showSender ? 1 : 0)
                .offset(x: vm.showSender ? 0 : -24)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: vm.showSender)

            arrowConnector
                .opacity(vm.showArrow ? 1 : 0)
                .scaleEffect(x: vm.showArrow ? 1 : 0, anchor: .leading)
                .animation(.easeOut(duration: 0.35), value: vm.showArrow)

            ParticipantCard(name: vm.receiverName, maskedCard: vm.receiverMaskedCard, isSender: false)
                .opacity(vm.showReceiver ? 1 : 0)
                .offset(x: vm.showReceiver ? 0 : 24)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: vm.showReceiver)
        }
        .padding(.horizontal, 20)
    }

    private var arrowConnector: some View {
        HStack(spacing: 2) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1.5)
            Image(systemName: "arrowtriangle.right.fill")
                .font(.system(size: 8))
                .foregroundStyle(Color(.systemGray3))
        }
        .frame(width: 32)
    }

    private var doneButton: some View {
        Button { vm.done() } label: {
            Text(Loc.Universal.done)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    NavigationStack {
        SuccessView(
            receiver: UserInfo(
                name: "John Appleseed",
                lastFourCardNumber: "4242",
                objectID: "abc123",
                userID: "usr456",
                peripheralIdentifier: UUID(),
                isConnected: true
            ),
            provider: AppProvider()
        )
    }
}
