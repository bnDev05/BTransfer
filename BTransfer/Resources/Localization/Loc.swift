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
}
