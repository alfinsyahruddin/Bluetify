//
//  BluetifyPeripheralKit.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import Foundation
import Combine
import CoreBluetooth
import UIKit

final class BluetifyPeripheralKit: NSObject, ObservableObject {
    @Published public var state: PeripheralState = .bluetoothUnavailable
    @Published public var deviceName: String = UIDevice.current.model
    @Published public var message: String = ""
    
    override init() {
        super.init()
    }

    private func startAdvertising() {
     
    }
    
    public func stopAdvertising() -> Void {
            
    }
    
    public func sendNotification(_ text: String) -> Void {
       
    }
}


extension BluetifyPeripheralKit: CBPeripheralManagerDelegate {
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
     
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
       
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
       
    }
}
