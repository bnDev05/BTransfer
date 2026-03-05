//
//  BluetoothService.swift
//  BTransfer
//
//  Wraps BluetoothInfoShare package.
//  Owns scanning, advertising, state observation, and device discovery.
//

import SwiftUI
import Combine
import CoreBluetooth
import BluetoothInfoShare

final class BluetoothService {
    @AppStorage(.cardIndex) var selectedCardIndex = 0
    let bluetoothStatePublisher: AnyPublisher<CBManagerState, Never>
    let discoveredDevicesPublisher: AnyPublisher<[CellInfoModel], Never>

    private let manager = BluetoothManager.shared
    private let peripheralHandler: PeripheralManagerDelegateHandler

    private let devicesSubject = CurrentValueSubject<[CellInfoModel], Never>([])
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.peripheralHandler = PeripheralManagerDelegateHandler(bluetoothManager: manager)
        self.bluetoothStatePublisher = manager.statePublisher
        self.discoveredDevicesPublisher = devicesSubject.eraseToAnyPublisher()

        setupPeripheral()
        observeDiscovery()
        observeConnectionEvents()
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
            .sink { [weak self] peripheral in
                guard let self else { return }
                guard
                    let localName = peripheral.name,
                    let cell = CellInfoModel.makeInfo(
                        advertisementLocalName: localName,
                        peripheral: peripheral,
                        isConnected: peripheral.state == .connected
                    )
                else { return }

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
        manager.startScan(
            serviceUUIDs: [BluetoothManager.dataSharingServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        )
    }

    func stopScanning() {
        manager.stopScan()
    }

    func connect(to cell: CellInfoModel) async throws -> CBPeripheral {
        try await manager.connect(cell.peripheral)
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
