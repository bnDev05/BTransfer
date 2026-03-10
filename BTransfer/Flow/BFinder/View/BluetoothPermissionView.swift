//
//  BluetoothPermissionView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import CoreBluetooth

struct BluetoothPermissionView: View {
    let state: CBManagerState

    private var title: String {
        switch state {
        case .unauthorized: return Loc.BluetoothPermissionTexts.accessRequired
        case .poweredOff:   return Loc.BluetoothPermissionTexts.powerOff
        default:            return Loc.BluetoothPermissionTexts.bluetoothUnavailable
        }
    }

    private var message: String {
        switch state {
        case .unauthorized:
            return Loc.BluetoothPermissionTexts.unauthorizedMessage
        case .poweredOff:
            return Loc.BluetoothPermissionTexts.poweredOffMessage
        default:
            return Loc.BluetoothPermissionTexts.notAvailableMessage
        }
    }

    private var actionLabel: String {
        state == .unauthorized ? Loc.BluetoothPermissionTexts.openSettings : Loc.BluetoothPermissionTexts.openControlCenter
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "wave.3.right.circle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if state == .unauthorized {
                Button(actionLabel) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
    }
}
