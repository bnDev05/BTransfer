//
//  BluetoothService.swift
//  BTransfer
//
//  Wraps BluetoothInfoShare package.
//

import SwiftUI
import Combine
import CoreBluetooth
import BluetoothInfoShare
import UIKit

final class BluetoothService {
    @AppStorage(.cardIndex) var selectedCardIndex = 0
    let bluetoothStatePublisher: AnyPublisher<CBManagerState, Never>
    let discoveredDevicesPublisher: AnyPublisher<[CellInfoModel], Never>

    private let manager = BluetoothManager.shared
    private let peripheralHandler: PeripheralManagerDelegateHandler
    private let devicesSubject = CurrentValueSubject<[CellInfoModel], Never>([])
    private var cancellables = Set<AnyCancellable>()
    private var lastSeenAt: [UUID: Date] = [:]

    private static let ttl: TimeInterval = 1
    private static let evictionInterval: TimeInterval = 1

    init() {
        self.peripheralHandler = PeripheralManagerDelegateHandler(bluetoothManager: manager)
        self.bluetoothStatePublisher = manager.statePublisher
        self.discoveredDevicesPublisher = devicesSubject.eraseToAnyPublisher()

        setupPeripheral()
        observeDiscovery()
        observeConnectionEvents()
        startEvictionTimer()
        observeAppLifecycle()
    }


    private func setupPeripheral() {
        manager.setupPeripheralManager(delegate: peripheralHandler)

        let card = Constants.cardNumbers[selectedCardIndex]
            .replacingOccurrences(of: " ", with: "")
        let info = AdvertisementInfo(
            lastFourCardNumber: String(card.suffix(4)),
            objectID: Constants.objectID,
            userID: Constants.userID,
            userName: Constants.username
        )
        manager.setAdvertisementInfo(info)
    }

    private func observeDiscovery() {
        manager.discoveryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral, advertisementData in
                guard let self else { return }
                guard
                    let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
                    let cell = CellInfoModel.makeInfo(
                        advertisementLocalName: localName,
                        peripheral: peripheral,
                        isConnected: peripheral.state == .connected
                    )
                else { return }

                self.lastSeenAt[peripheral.identifier] = Date()

                var current = self.devicesSubject.value
                if let index = current.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
                    current[index] = cell
                } else if !current.contains(where: { $0.userID == cell.userID }) {
                    current.append(cell)
                }
                self.devicesSubject.send(current)
            }
            .store(in: &cancellables)
    }

    private func startEvictionTimer() {
        Timer.publish(every: Self.evictionInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.evictStaledDevices()
            }
            .store(in: &cancellables)
    }

    private func observeAppLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.manager.stopAdvertising()
                self?.manager.stopScan()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                self.manager.startAdvertising()
                self.manager.stopScan()
                self.devicesSubject.send([])
                self.lastSeenAt.removeAll()
                self.manager.startScan(
                    serviceUUIDs: [BluetoothManager.dataSharingServiceUUID],
                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
                )
            }
            .store(in: &cancellables)
    }

    private func evictStaledDevices() {
        let now = Date()
        let staleIDs = lastSeenAt
            .filter { now.timeIntervalSince($0.value) > Self.ttl }
            .map(\.key)

        guard !staleIDs.isEmpty else { return }

        staleIDs.forEach { lastSeenAt.removeValue(forKey: $0) }

        let updated = devicesSubject.value
            .filter { !staleIDs.contains($0.peripheral.identifier) }

        devicesSubject.send(updated)
    }


    private func observeConnectionEvents() {
        manager.connectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in
                self?.updateConnectionState(for: peripheral.identifier, isConnected: true)
            }
            .store(in: &cancellables)

        manager.disconnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in
                self?.updateConnectionState(for: peripheral.identifier, isConnected: false)
            }
            .store(in: &cancellables)
    }

    private func updateConnectionState(for id: UUID, isConnected: Bool) {
        var current = devicesSubject.value
        if let index = current.firstIndex(where: { $0.peripheral.identifier == id }) {
            current[index].isConnected = isConnected
            devicesSubject.send(current)
        }
    }

    func startScanning() {
        devicesSubject.send([])
        lastSeenAt.removeAll()
        manager.startScan(
            serviceUUIDs: [BluetoothManager.dataSharingServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        )
    }

    func stopScanning() {
        manager.stopScan()
    }

    func connect(to cell: CellInfoModel) async throws -> CBPeripheral {
        try await Task(priority: .userInitiated) {
            try await manager.connect(cell.peripheral)
        }.value
    }

    @discardableResult
    func disconnect(from cell: CellInfoModel) async -> CBPeripheral {
        await Task(priority: .userInitiated) {
            await manager.disconnect(cell.peripheral)
        }.value
    }

    func updateAdvertisedCard(lastFour: String) {
        let info = AdvertisementInfo(
            lastFourCardNumber: lastFour,
            objectID: Constants.objectID,
            userID: Constants.userID,
            userName: Constants.username
        )
        manager.setAdvertisementInfo(info)
        manager.stopAdvertising()
        manager.startAdvertising()
    }
}
