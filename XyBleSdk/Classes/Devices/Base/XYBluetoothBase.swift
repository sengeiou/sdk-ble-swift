//
//  XYBluetoothBase.swift
//  XYSdkSample
//
//  Created by Darren Sutherland on 9/25/18.
//  Copyright © 2018 Darren Sutherland. All rights reserved.
//

import CoreBluetooth

// Basic protocol for all BLE devices 
public protocol XYBluetoothBase {
    var rssi: Int { get set }
    var powerLevel: UInt8 { get set }
    var name: String { get }
    var id: String { get }
    var lastPulseTime: Date? { get }
    var totalPulseCount: Int { get }
    var proximity: XYDeviceProximity { get }

    func update(_ rssi: Int, powerLevel: UInt8)

    var supportedServices: [CBUUID] { get }
}

public extension XYBluetoothBase {

    var proximity: XYDeviceProximity {
        return XYDeviceProximity.fromSignalStrength(self.rssi)
    }

}

public func ==(lhs: XYBluetoothBase, rhs: XYBluetoothBase) -> Bool {
    return lhs.id == rhs.id
}
