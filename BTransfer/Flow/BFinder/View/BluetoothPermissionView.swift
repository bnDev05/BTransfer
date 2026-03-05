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
        case .unauthorized: return "Bluetooth Access Required"
        case .poweredOff:   return "Bluetooth is Off"
        default:            return "Bluetooth Unavailable"
        }
    }

    private var message: String {
        switch state {
        case .unauthorized:
            return "Please allow Bluetooth access in Settings so you can find nearby devices."
        case .poweredOff:
            return "Turn on Bluetooth in Control Center or Settings to find nearby devices."
        default:
            return "Bluetooth is not available on this device."
        }
    }

    private var actionLabel: String {
        state == .unauthorized ? "Open Settings" : "Open Control Center"
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
