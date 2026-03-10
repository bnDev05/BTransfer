//
//  CardPickerSheet.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine

struct CardPickerSheet: View {
    @ObservedObject var vm: BFinderViewModel
    
    let cards: [String] = Constants.cardNumbers

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Loc.CardPickerSheetTexts.selectToBroadcast)
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(cards.enumerated()), id: \.element) { index, card in
                        Button {
                            vm.selectCard(at: index)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(cards[index])
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.primary)
                                    Text("•••• \(String(cards[index].replacingOccurrences(of: " ", with: "").suffix(4)))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if index == vm.selectedCardIndex {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                        .fontWeight(.semibold)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if index < cards.indices.last ?? 0 {
                            Divider().padding(.leading, 20)
                        }
                    }
                }
            }
        }
    }
}
