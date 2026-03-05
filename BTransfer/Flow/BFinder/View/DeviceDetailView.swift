//
//  DeviceDetailView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import BluetoothInfoShare

struct DeviceDetailView: View {
    let device: CellInfoModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "iphone.radiowaves.left.and.right")
                .font(.system(size: 52))
                .foregroundStyle(Color.accentColor)

            Text(device.name)
                .font(.title2.bold())
            Text("•••• \(device.lastFourCardNumber)")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Device")
        .navigationBarTitleDisplayMode(.inline)
    }
}
