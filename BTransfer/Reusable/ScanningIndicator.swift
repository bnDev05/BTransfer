//
//  ScanningIndicator.swift
//  BTransfer
//
//  Created by Behruz Norov on 05/03/26.
//

import SwiftUI

struct ScanningIndicator: View {
    let phase: ScanPhase

    var body: some View {
        HStack(spacing: 8) {
            switch phase {
            case .scanning(let secondsLeft):
                ProgressView()
                    .tint(.accentColor)
                Text("Scanning… \(secondsLeft)s")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            case .finished:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Scan complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            case .noResults:
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                Text("No devices found")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
