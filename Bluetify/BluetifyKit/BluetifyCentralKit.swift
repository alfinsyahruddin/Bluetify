//
//  BluetifyCentralKit.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import Foundation
import Combine
import CoreBluetooth

final class BluetifyCentralKit: NSObject, ObservableObject {
    @Published public var state: CentralState = .bluetoothUnavailable
    @Published public var deviceName: String = ""
    @Published public var notification: String = ""
    
    
    override init() {
        super.init()
    }
    
    
    public func startScanning() -> Void {
     
    }

    public func stopScanning() -> Void {
     
    }
            
    public func readDeviceName() -> Void {
        
    }
    
    public func sendMessage(_ text: String) -> Void {
       
    }
    
    public func subscribeNotification() -> Void {
   
    }
}


extension BluetifyCentralKit: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
       
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
      
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       
    }
}

extension BluetifyCentralKit: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
       
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
      
    }
}
