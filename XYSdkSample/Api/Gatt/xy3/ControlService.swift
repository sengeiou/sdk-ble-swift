//
//  ControlService.swift
//  XYSdkSample
//
//  Created by Darren Sutherland on 9/25/18.
//  Copyright © 2018 Darren Sutherland. All rights reserved.
//

import CoreBluetooth

public enum ControlService: String, XYServiceCharacteristic {

    public var serviceUuid: CBUUID { return ControlService.serviceUuid }

    case buzzer
    case handshake
    case version
    case buzzerSelect
    case surge
    case button
    case disconnect

    private static let serviceUuid = CBUUID(string: "F014ED15-0439-3000-E001-00001001FFFF")

    public var characteristicUuid: CBUUID {
        return ControlService.uuids[self]!
    }

    public var characteristicType: XYServiceCharacteristicType {
        switch self {
        case .buzzer, .handshake, .buzzerSelect, .surge, .button, .disconnect:
            return .integer
        case .version:
            return .string
        }
    }

    private static let uuids: [ControlService: CBUUID] = [
        buzzer : CBUUID(string: "F014FFF1-0439-3000-E001-00001001FFFF"),
        handshake : CBUUID(string: "F014FFF2-0439-3000-E001-00001001FFFF"),
        version : CBUUID(string: "F014FFF4-0439-3000-E001-00001001FFFF"),
        buzzerSelect : CBUUID(string: "F014FFF6-0439-3000-E001-00001001FFFF"),
        surge : CBUUID(string: "F014FFF7-0439-3000-E001-00001001FFFF"),
        button : CBUUID(string: "F014FFF8-0439-3000-E001-00001001FFFF"),
        disconnect : CBUUID(string: "F014FFF9-0439-3000-E001-00001001FFFF")
    ]
}