//
//  State.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import Foundation

enum PeripheralState: String {
    case bluetoothUnavailable
    case advertising
}

enum CentralState {
    case bluetoothUnavailable
    case scanning
    case connected
}
