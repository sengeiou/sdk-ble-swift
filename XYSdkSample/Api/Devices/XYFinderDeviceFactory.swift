//
//  XYFinderDeviceFactory.swift
//  XYSdkSample
//
//  Created by Darren Sutherland on 9/7/18.
//  Copyright © 2018 Darren Sutherland. All rights reserved.
//

import Foundation

public class XYFinderDeviceFactory {

    class func build(from iBeacon: XYIBeaconDefinition, rssi: Int = XYDeviceProximity.none.rawValue) -> XYFinderDevice? {
        guard let family = XYFinderDeviceFamily.get(from: iBeacon) else { return nil }
        switch family {
        case .xy4:
            return XY4BluetoothDevice(iBeacon, rssi: rssi)
        case .xy3:
            return XY3BluetoothDevice(iBeacon, rssi: rssi)
        default:
            return nil
        }
    }

    class func build(from family: XYFinderDeviceFamily) -> XYFinderDevice? {
        let id = [family.prefix, family.uuid.uuidString.lowercased()].joined(separator: ":")
        switch family {
        case .xy4:
            return XY4BluetoothDevice(id)
        case .xy3:
            return XY3BluetoothDevice(id)
        default:
            return nil
        }
    }

}