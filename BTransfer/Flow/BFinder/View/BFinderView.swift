//
//  BFinderView.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI
import CoreBluetooth
import BluetoothInfoShare

struct BFinderView: View {
    @StateObject private var vm: BFinderViewModel
    init(provider: AppProvider) {
        _vm = StateObject(wrappedValue: BFinderViewModel(provider: provider))
    }

    var body: some View {
        NavigationStack {
            Group {
                if !vm.isBluetoothReady {
                    BluetoothPermissionView(state: vm.bluetoothState)
                } else {
                    mainContent
                }
            }
            .navigationTitle(Loc.BFinderTexts.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .alert(Loc.BFinderTexts.noFoundAlertTitle, isPresented: $vm.showNoDevicesAlert) {
            Button(Loc.Universal.retry) { vm.retryScanning() }
            Button(Loc.Universal.cancel, role: .cancel) {}
        } message: {
            Text(Loc.BFinderTexts.noFoundAlertMessage)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            switch vm.scanPhase {
            case .scanning:
                EmptyView()
            case .noResults, .finished:
                Button {
                    vm.retryScanning()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                senderSection
                Divider().padding(.vertical, 8)
                devicesSection
                scannerFooter
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }

    private var senderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Loc.Universal.you)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            Button {
                vm.showCardPicker()
            } label: {
                SenderCell(info: vm.senderInfo)
            }
            .buttonStyle(.plain)
        }
    }

    private var devicesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !vm.discoveredDevices.isEmpty {
                Text(Loc.BFinderTexts.nearbyDevices)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }

            VStack(spacing: 0) {
                ForEach(vm.discoveredDevices) { cell in
                    Button {
                        vm.goToTransfer(cell: cell)
                    } label: {
                        DiscoveredDeviceCell(
                            cell: cell,
                            isLoading: vm.loadingPeripheralID == cell.peripheral.identifier
                        )
                    }
                    .buttonStyle(.plain)

                    if cell.id != vm.discoveredDevices.last?.id {
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var scannerFooter: some View {
        VStack(spacing: 12) {
            ScanningIndicator(phase: vm.scanPhase)

            Text(Loc.BFinderTexts.info)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

#Preview {
    BFinderView(provider: AppProvider())
}
