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
    
    private var peripheralManager: CBPeripheralManager!
    
    private var deviceNameCharacteristic: CBMutableCharacteristic?
    private var messageCharacteristic: CBMutableCharacteristic?
    private var notificationCharacteristic: CBMutableCharacteristic?

    override init() {
        super.init()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    private func startAdvertising() {
        print("[PERIPHERAL] Start Advertising...")

        peripheralManager.removeAllServices()
        
        self.deviceNameCharacteristic = CBMutableCharacteristic(
            type: BluetifyUUID.deviceNameCharacteristic.cbuuid,
            properties: [.read],
            value: nil,
            permissions: [.readable]
        )
        
        self.deviceNameCharacteristic!.descriptors = [
            CBMutableDescriptor(
                type: CBUUID(string: CBUUIDCharacteristicUserDescriptionString),
                value: NSString(string: "Characteristic for reading peripheral device names.")
            )
        ]
                
        self.messageCharacteristic = CBMutableCharacteristic(
            type: BluetifyUUID.messageCharacteristic.cbuuid,
            properties: [.write],
            value: nil,
            permissions: [.writeable]
        )
        
        self.notificationCharacteristic = CBMutableCharacteristic(
            type: BluetifyUUID.notificationCharacteristic.cbuuid,
            properties: [.notify],
            value: nil,
            permissions: [.readable]
        )
        
        let mainService = CBMutableService(type: BluetifyUUID.mainService.cbuuid, primary: true)
                                
        mainService.characteristics = [
            deviceNameCharacteristic,
            messageCharacteristic,
            notificationCharacteristic
        ].compactMap { $0 }
        
        peripheralManager.add(mainService)
        
        state = .advertising
        peripheralManager.startAdvertising([
            CBAdvertisementDataLocalNameKey: Bluetify.peripheralName.rawValue,
            CBAdvertisementDataServiceUUIDsKey: [BluetifyUUID.mainService.cbuuid]
        ])
    }
    
    public func stopAdvertising() -> Void {
        print("[PERIPHERAL] Stop Advertising.")

        state = .bluetoothUnavailable
        peripheralManager.stopAdvertising()        
    }
    
    public func sendNotification(_ text: String) -> Void {
        guard let notificationCharacteristic else { return }
        
        peripheralManager.updateValue(
            text.asData(),
            for: notificationCharacteristic,
            onSubscribedCentrals: notificationCharacteristic.subscribedCentrals
        )
        
        print("[PERIPHERAL] Send Notification: \(text)")
    }
}


extension BluetifyPeripheralKit: CBPeripheralManagerDelegate {
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        let characteristic = BluetifyUUID(rawValue: request.characteristic.uuid.uuidString)
        
        switch characteristic {
        case .deviceNameCharacteristic:
            request.value = deviceName.asData()
        default:
            break
        }
                
        peripheral.respond(to: request, withResult: .success)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            let characteristic = BluetifyUUID(rawValue: request.characteristic.uuid.uuidString)
            
            switch characteristic {
            case .messageCharacteristic:
                guard let newMessage = request.value?.asString() else { break }
                print("[PERIPHERAL] New Message: \(newMessage)")
                
                message = newMessage
            default:
                break
            }

            peripheral.respond(to: request, withResult: .success)
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("[PERIPHERAL] State: \(peripheral.state)")

        switch peripheral.state {
        case .unknown, .unsupported, .unauthorized, .resetting, .poweredOff:
            self.state = .bluetoothUnavailable
        case .poweredOn:
            self.startAdvertising()
        @unknown default:
            self.state = .bluetoothUnavailable
        }
    }
}
