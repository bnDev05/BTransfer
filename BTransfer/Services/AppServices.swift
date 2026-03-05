//
//  AppServices.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

final class AppServices {
    lazy var bluetoothService: BluetoothService = {
        return BluetoothService()
    }()
    init() {}
}
