//
//  SenderCell.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct SenderCell: View {
    let info: SenderInfo

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.accentColor)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(info.username)
                    .font(.subheadline.weight(.semibold))
                Text("•••• •••• •••• \(info.lastFourCard)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

