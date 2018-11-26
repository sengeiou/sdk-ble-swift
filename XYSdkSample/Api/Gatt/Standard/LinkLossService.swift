//
//  LinkLossService.swift
//  XYSdkSample
//
//  Created by Darren Sutherland on 9/25/18.
//  Copyright © 2018 Darren Sutherland. All rights reserved.
//

import CoreBluetooth

public enum LinkLossService: String, XYServiceCharacteristic {

    public var serviceUuid: CBUUID { return LinkLossService.serviceUuid }

    case alertLevel

    public var characteristicUuid: CBUUID {
        return LinkLossService.uuids[self]!
    }

    public var characteristicType: XYServiceCharacteristicType {
        return .integer
    }

    private static let serviceUuid = CBUUID(string: "00001803-0000-1000-8000-00805F9B34FB")

    private static let uuids: [LinkLossService: CBUUID] = [
        .alertLevel : CBUUID(string: "00002a06-0000-1000-8000-00805f9b34fb")
    ]
}