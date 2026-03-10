//
//  Loc.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

enum Loc {
    enum Universal {
        static let retry: String = "Universal.text.retry".localized
        static let cancel: String = "Universal.text.cancel".localized
        static let you: String = "Universal.text.you".localized
        static let done: String = "Universal.text.done".localized
        static let from: String = "Universal.text.from".localized
        static let to: String = "Universal.text.to".localized

    }
    
    enum SplashTexts {
        static let title: String = "SplashTexts.text.title".localized
        static let subtitle: String = "SplashTexts.text.subtitle".localized
    }
    
    enum BFinderTexts {
        static let title: String = "BFinderTexts.text.title".localized
        static let noFoundAlertTitle: String = "BFinderTexts.text.noFoundAlertTitle".localized
        static let noFoundAlertMessage: String = "BFinderTexts.text.noFoundAlertMessage".localized
        static let nearbyDevices: String = "BFinderTexts.text.nearbyDevices".localized
        static let lookingForNearbyDevices: String = "BFinderTexts.text.lookingForNearbyDevices".localized
        static let info: String = "BFinderTexts.text.info".localized
    }
    
    enum BluetoothPermissionTexts {
        static let accessRequired: String = "BluetoothPermissionTexts.text.accessRequired".localized
        static let powerOff: String = "BluetoothPermissionTexts.text.powerOff".localized
        static let bluetoothUnavailable: String = "BFinderTexts.text.bluetoothUnavailable".localized
        
        static let unauthorizedMessage: String = "BluetoothPermissionTexts.text.unauthorizedMessage".localized
        static let poweredOffMessage: String = "BluetoothPermissionTexts.text.poweredOffMessage".localized
        static let notAvailableMessage: String = "BluetoothPermissionTexts.text.notAvailableMessage".localized
        
        static let openSettings: String = "BluetoothPermissionTexts.text.openSettings".localized
        static let openControlCenter: String = "BluetoothPermissionTexts.text.openControlCenter".localized
    }
    
    enum CardPickerSheetTexts {
        static let selectToBroadcast: String = "CardPickerSheetTexts.text.selectToBroadcast".localized
    }
    
    enum DeviceDetailTexts {
        static let details: String = "DeviceDetailTexts.text.details".localized
    }
    
    enum TransferTexts {
        static let title: String = "TransferTexts.text.title".localized
        static let amount: String = "TransferTexts.text.amount".localized
    }
}
