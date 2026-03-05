//
//  CardView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct CardView: View {
    let label: String
    let name: String
    let maskedCard: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.bottom, 12)

            Spacer()

            Text(name)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Spacer().frame(height: 6)

            Text(maskedCard)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
                .kerning(2)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(
            LinearGradient(
                colors: label == "From"
                    ? [Color.accentColor, Color.accentColor.opacity(0.7)]
                    : [Color(.systemGray2), Color(.systemGray3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

