//
//  BluetifyUUID.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import Foundation
import CoreBluetooth


enum BluetifyUUID: String {
    case mainService = "00000000-0000-0000-0000-000000000001"
    
    case deviceNameCharacteristic = "10000000-0000-0000-0000-000000000001"
    case messageCharacteristic = "10000000-0000-0000-0000-000000000002"
    case notificationCharacteristic = "10000000-0000-0000-0000-000000000003"
}

extension BluetifyUUID {
    var uuid: UUID {
        UUID(uuidString: self.rawValue)!
    }
    
    var cbuuid: CBUUID {
        CBUUID(nsuuid: self.uuid)
    }
}
