//
//  DiscoveredCell.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import BluetoothInfoShare

struct DiscoveredDeviceCell: View {
    let cell: CellInfoModel
    var isLoading: Bool = false

    var body: some View {
        ZStack {
            BackView()
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "iphone")
                            .foregroundStyle(.secondary)
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(cell.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("•••• •••• •••• \(cell.lastFourCardNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .tint(.secondary)
                        .scaleEffect(0.7)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
    }
}
