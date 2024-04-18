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
    
    private var centralManager: CBCentralManager!

    private var peripheral: CBPeripheral?
    private var deviceNameCharacteristic: CBCharacteristic?
    private var messageCharacteristic: CBCharacteristic?
    private var notificationCharacteristic: CBCharacteristic?

    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public func startScanning() -> Void {
        print("[CENTRAL] Start Scanning...")
        state = .scanning
        centralManager.scanForPeripherals(withServices: [BluetifyUUID.mainService.cbuuid])
    }

    public func stopScanning() -> Void {
        print("[CENTRAL] Stop Scanning.")
        centralManager.stopScan()
    }
            
    public func readDeviceName() -> Void {
        guard let deviceNameCharacteristic else { return }
        peripheral?.readValue(for: deviceNameCharacteristic)
    }
    
    public func sendMessage(_ text: String) -> Void {
        guard let messageCharacteristic else { return }
        peripheral?.writeValue(text.asData(), for: messageCharacteristic, type: .withResponse)
    }
    
    public func subscribeNotification() -> Void {
        guard let notificationCharacteristic else { return }
        peripheral?.setNotifyValue(true, for: notificationCharacteristic)
    }
}


extension BluetifyCentralKit: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("[CENTRAL] State: \(central.state)")

        switch central.state {
        case .unknown, .unsupported, .unauthorized, .resetting, .poweredOff:
            self.state = .bluetoothUnavailable
        case .poweredOn:
            self.startScanning()
        @unknown default:
            self.state = .bluetoothUnavailable
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let peripheralName = peripheral.name else { return }
        
        print("[CENTRAL] Peripheral: `\(peripheralName)`")
        
        print("[CENTRAL] Connecting...")
        centralManager.connect(peripheral, options: nil)
        
        self.peripheral = peripheral
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("[CENTRAL] Connected")

        peripheral.delegate = self
        peripheral.discoverServices(nil)
                
        state = .connected
    }
}

extension BluetifyCentralKit: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
       
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
   
        print("[CENTRAL] Total characteristics: \(characteristics.count)")
        
        for characteristic in characteristics {
            if characteristic.uuid == BluetifyUUID.deviceNameCharacteristic.cbuuid {
                self.deviceNameCharacteristic = characteristic
                self.readDeviceName()
            }
            
            if characteristic.uuid == BluetifyUUID.messageCharacteristic.cbuuid {
                self.messageCharacteristic = characteristic
            }
                        
            if characteristic.uuid == BluetifyUUID.notificationCharacteristic.cbuuid {
                self.notificationCharacteristic = characteristic
                self.subscribeNotification()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BluetifyUUID.deviceNameCharacteristic.cbuuid {
            let deviceName = characteristic.value?.asString() ?? "-"
            print("[CENTRAL] DEVICE NAME: \(deviceName)")
            self.deviceName = deviceName
        }
        
        if characteristic.uuid == BluetifyUUID.notificationCharacteristic.cbuuid {
            let notification = characteristic.value?.asString() ?? "-"
            print("[CENTRAL] NOTIFICATION: \(notification)")
            self.notification = notification
        }
    }
}
