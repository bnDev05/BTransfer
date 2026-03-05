//
//  UserInfo.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import Foundation
import CoreBluetooth
import BluetoothInfoShare

struct UserInfo: Identifiable, Hashable {

    public let id: UUID
    public let name: String
    public let lastFourCardNumber: String
    public let objectID: String
    public let userID: String
    public let peripheralIdentifier: UUID
    public var isConnected: Bool

    public init(from model: CellInfoModel) {
        self.id = model.id
        self.name = model.name
        self.lastFourCardNumber = model.lastFourCardNumber
        self.objectID = model.objectID
        self.userID = model.userID
        self.peripheralIdentifier = model.peripheral.identifier
        self.isConnected = model.isConnected
    }

    public init(
        id: UUID = UUID(),
        name: String,
        lastFourCardNumber: String,
        objectID: String,
        userID: String,
        peripheralIdentifier: UUID,
        isConnected: Bool
    ) {
        self.id = id
        self.name = name
        self.lastFourCardNumber = lastFourCardNumber
        self.objectID = objectID
        self.userID = userID
        self.peripheralIdentifier = peripheralIdentifier
        self.isConnected = isConnected
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(lastFourCardNumber)
        hasher.combine(objectID)
        hasher.combine(userID)
        hasher.combine(peripheralIdentifier)
        hasher.combine(isConnected)
    }
    
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.lastFourCardNumber == rhs.lastFourCardNumber &&
        lhs.objectID == rhs.objectID &&
        lhs.userID == rhs.userID &&
        lhs.peripheralIdentifier == rhs.peripheralIdentifier &&
        lhs.isConnected == rhs.isConnected
    }
}

extension CellInfoModel {
    func toHashable() -> UserInfo {
        UserInfo(from: self)
    }
}

extension UserInfo {
    func withIsConnected(_ isConnected: Bool) -> UserInfo {
        UserInfo(
            id: self.id,
            name: self.name,
            lastFourCardNumber: self.lastFourCardNumber,
            objectID: self.objectID,
            userID: self.userID,
            peripheralIdentifier: self.peripheralIdentifier,
            isConnected: isConnected
        )
    }
}
