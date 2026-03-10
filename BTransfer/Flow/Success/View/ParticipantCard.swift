//
//  ParticipantCard.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct ParticipantCard: View {
    let name: String
    let maskedCard: String
    let isSender: Bool

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(isSender ? Color.accentColor.opacity(0.15) : Color(.tertiarySystemFill))
                .frame(width: 52, height: 52)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(isSender ? Color.accentColor : Color(.systemGray2))
                        .font(.title3)
                }

            Text(name)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)

            Text(maskedCard)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .kerning(1)
        }
        .frame(maxWidth: .infinity)
    }
}
