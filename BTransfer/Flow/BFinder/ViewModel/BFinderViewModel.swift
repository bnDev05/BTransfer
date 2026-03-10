//
//  BFinderViewModel.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import Combine
import CoreBluetooth
import BluetoothInfoShare

final class BFinderViewModel: ObservableObject, Hashable {
    let coordinator: AppCoordinator
    @AppStorage(.cardIndex) var selectedCardIndex = 0
    @Published private(set) var bluetoothState: CBManagerState = .unknown
    @Published private(set) var discoveredDevices: [CellInfoModel] = []
    @Published private(set) var scanPhase: ScanPhase = .scanning(secondsLeft: 60)
    @Published var showNoDevicesAlert: Bool = false

    @Published private(set) var loadingPeripheralID: UUID? = nil

    private var navigationLocked: Bool { loadingPeripheralID != nil }

    var isBluetoothReady: Bool { bluetoothState == .poweredOn }

    static func == (lhs: BFinderViewModel, rhs: BFinderViewModel) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    
    var senderInfo: SenderInfo {
        SenderInfo(
            username: Constants.username,
            lastFourCard: lastFour(for: selectedCardIndex)
        )
    }


    private let bluetooth: BluetoothService
    private var scanTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    static let scanDuration = 60

    init(provider: AppProvider) {
        self.coordinator = provider.coordinator
        self.bluetooth = provider.services.bluetoothService
        observeBluetoothState()
        observeDiscoveredDevices()
    }

    private func observeBluetoothState() {
        bluetooth.bluetoothStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.bluetoothState = state
                if state == .poweredOn {
                    self.beginScan()
                } else {
                    self.stopScan()
                }
            }
            .store(in: &cancellables)
    }

    private func observeDiscoveredDevices() {
        bluetooth.discoveredDevicesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$discoveredDevices)
    }

    func beginScan() {
        guard isBluetoothReady else { return }
        bluetooth.startScanning()
        startCountdown()
    }

    func stopScan() {
        bluetooth.stopScanning()
        scanTimer?.cancel()
    }

    private func startCountdown() {
        var remaining = Self.scanDuration
        scanPhase = .scanning(secondsLeft: remaining)

        scanTimer?.cancel()
        scanTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                remaining -= 1

                if remaining > 0 {
                    self.scanPhase = .scanning(secondsLeft: remaining)
                } else {
                    self.finishScan()
                }
            }
    }

    private func finishScan() {
        stopScan()
        if discoveredDevices.isEmpty {
            scanPhase = .noResults
            showNoDevicesAlert = true
        } else {
            scanPhase = .finished
        }
    }

    func retryScanning() {
        showNoDevicesAlert = false
        beginScan()
    }
    
    func selectCard(at index: Int) {
        selectedCardIndex = index
        coordinator.dismissSheet()
        bluetooth.updateAdvertisedCard(lastFour: lastFour(for: index))
    }

    private func lastFour(for index: Int) -> String {
        let card = Constants.cardNumbers[index].replacingOccurrences(of: " ", with: "")
        return String(card.suffix(4))
    }
    
    func showCardPicker() {
        coordinator.presentSheet(.cards(vm: self))
    }
    
    func goToTransfer(cell: CellInfoModel) {
        guard !navigationLocked else { return }
        loadingPeripheralID = cell.peripheral.identifier
        coordinator.push(.transfer(userData: cell.toHashable()))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.loadingPeripheralID = nil
        }
    }
}
