//
//  XY3BluetoothDevice.swift
//  XYSdkSample
//
//  Created by Darren Sutherland on 9/25/18.
//  Copyright © 2018 Darren Sutherland. All rights reserved.
//

import CoreBluetooth

public class XY3BluetoothDevice: XYBluetoothDeviceBase, XYFinderDevice {
    public let
    iBeacon: XYIBeaconDefinition?

    public let family: XYFinderDeviceFamily = .xy3

    public init(_ id: String, iBeacon: XYIBeaconDefinition? = nil, rssi: Int = XYDeviceProximity.none.rawValue) {
        self.iBeacon = iBeacon
        super.init(id, rssi: rssi)
    }

    public convenience init(_ iBeacon: XYIBeaconDefinition, rssi: Int = XYDeviceProximity.none.rawValue) {
        self.init(iBeacon.xyId(from: .xy3), iBeacon: iBeacon, rssi: rssi)
    }

    public var connectableServices: [CBUUID] {
        guard let major = iBeacon?.major, let minor = iBeacon?.minor else { return [] }

        func getServiceUuid(_ connectablePowerLevel: UInt8) -> CBUUID {
            let uuidSource = NSUUID(uuidString: self.family.uuid.uuidString)
            let uuidBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
            uuidSource?.getBytes(uuidBytes)
            for i in (0...11) {
                uuidBytes[i] = uuidBytes[i + 4];
            }
            uuidBytes[13] = UInt8(major & 0x00ff)
            uuidBytes[12] = UInt8((major & 0xff00) >> 8)
            uuidBytes[15] = UInt8(minor & 0x00f0) | 0x04
            uuidBytes[14] = UInt8((minor & 0xff00) >> 8)

            return CBUUID(data: Data(bytes:uuidBytes, count:16))
        }

        return [XYFinderDeviceFamily.powerLow, XYFinderDeviceFamily.powerHigh].map { getServiceUuid($0) }
    }

}




/*
public class XY3BluetoothDevice: XYBaseBluetoothDevice, XYFinderDevice {

    public let
    iBeacon: XYIBeaconDefinition?

    public let family: XYFinderDeviceFamily = .xy3

    public init(_ id: String, iBeacon: XYIBeaconDefinition? = nil, rssi: Int = XYDeviceProximity.none.rawValue) {
        self.iBeacon = iBeacon
        super.init(family.uuid, id: id, rssi: rssi)
    }

    public convenience init(_ iBeacon: XYIBeaconDefinition, rssi: Int = XYDeviceProximity.none.rawValue) {
        self.init(iBeacon.xyId(from: .xy3), iBeacon: iBeacon, rssi: rssi)
    }

    public var connectableServices: [CBUUID] {
        guard let major = iBeacon?.major, let minor = iBeacon?.minor else { return [] }

        func getServiceUuid(_ connectablePowerLevel: UInt8) -> CBUUID {
            let uuidSource = NSUUID(uuidString: self.family.uuid.uuidString)
            let uuidBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
            uuidSource?.getBytes(uuidBytes)
            for i in (0...11) {
                uuidBytes[i] = uuidBytes[i + 4];
            }
            uuidBytes[13] = UInt8(major & 0x00ff)
            uuidBytes[12] = UInt8((major & 0xff00) >> 8)
            uuidBytes[15] = UInt8(minor & 0x00f0) | 0x04
            uuidBytes[14] = UInt8((minor & 0xff00) >> 8)

            return CBUUID(data: Data(bytes:uuidBytes, count:16))
        }

        return [XYFinderDeviceFamily.powerLow, XYFinderDeviceFamily.powerHigh].map { getServiceUuid($0) }
    }

}
*/