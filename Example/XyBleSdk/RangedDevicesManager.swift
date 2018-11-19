//
//  RangedDevicesManager.swift
//  XyBleSdk_Example
//
//  Created by Darren Sutherland on 9/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CoreBluetooth
import XyBleSdk

protocol RangedDevicesManagerDelegate: class {
    func reloadTableView()
    func showDetails()
    func buttonPressed(on device: XYFinderDevice)
}

class MockRangedDevicesManager: NSObject, UITableViewDataSource {
    var rangedDevices = [XYFinderDevice]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: CGRect.zero)
    }

    func startRanging() {}
    func stopRanging() {}

    func scan(for deviceIndex: NSInteger) {}

    func disconnect() {}

    func setDelegate(_ delegate: RangedDevicesManagerDelegate) {}
}

class RangedDevicesManager: NSObject {

    fileprivate let central = XYCentral.instance
    fileprivate let scanner = XYSmartScan.instance

    fileprivate(set) var rangedDevices = [XYFinderDevice]()
    fileprivate(set) var selectedDevice: XYFinderDevice?

    fileprivate weak var delegate: RangedDevicesManagerDelegate?

    fileprivate(set) var subscriptionUuid: UUID?

    static let instance = RangedDevicesManager()

    private override init() {
        super.init()
        self.subscriptionUuid = XYFinderDeviceEventManager.subscribe(to: [.buttonPressed, .connected, .alreadyConnected]) { event in
            switch event {
            case .buttonPressed(let device, _):
                guard let currentDevice = self.selectedDevice, currentDevice == device else { return }
                self.delegate?.buttonPressed(on: device)
            case .connected, .alreadyConnected:
                DispatchQueue.main.async {
                    self.delegate?.showDetails()
                }
            default:
                break
            }
        }
    }

    func setDelegate(_ delegate: RangedDevicesManagerDelegate) {
        self.delegate = delegate
    }

    func startRanging() {
        if central.state != .poweredOn {
            central.setDelegate(self, key: "RangedDevicesManager")
            central.enable()
        } else {
            scanner.start(mode: .foreground)
        }
    }

    func stopRanging() {
        guard central.state == .poweredOn else { return }
        scanner.stop()
    }

    func scan(for deviceIndex: NSInteger) {
        guard
            let device = self.rangedDevices[safe: deviceIndex]
            else { return }

        self.selectedDevice = device
        self.selectedDevice?.connect()
    }

    func disconnect() {
        guard let device = selectedDevice else { return }
        device.disconnect()
    }
}

extension RangedDevicesManager: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rangedDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rangedDeviceCell") as! RangedDeviceTableViewCell
        let device = rangedDevices[indexPath.row]

        let directive = RangedDeviceCellDirective(
            name:  device.family.familyName,
            major: device.iBeacon?.major ?? 0,
            rssi: device.rssi,
            uuid: device.uuid,
            connected: false,
            minor: device.iBeacon?.minor ?? 0,
            pulses: device.totalPulseCount)

        cell.populate(from: directive)
        cell.accessoryType = device.powerLevel == UInt(8) ? .checkmark : .none
        return cell
    }
}

extension RangedDevicesManager: XYCentralDelegate {
    func located(peripheral: XYPeripheral) {}
    func connected(peripheral: XYPeripheral) {}
    func timeout() {}
    func couldNotConnect(peripheral: XYPeripheral) {}
    func disconnected(periperhal: XYPeripheral) {}

    func stateChanged(newState: CBManagerState) {
        if newState == .poweredOn {
            self.scanner.start(mode: .foreground)
            self.scanner.setDelegate(self, key: "RangedDevicesManager")
        }
    }
}

extension RangedDevicesManager: XYSmartScanDelegate {

    func smartScan(detected devices: [XYFinderDevice], family: XYFinderDeviceFamily) {
        DispatchQueue.main.async {
            var rangedWithoutCurrent = self.rangedDevices.filter { $0.family != family }

            devices.forEach { device in
                // Only show those in range
                if device.rssi != 0 && device.rssi > -95 {
                    rangedWithoutCurrent.append(device)
                }
            }

            self.rangedDevices = rangedWithoutCurrent.sorted(by: { ($0.powerLevel, $0.rssi, $0.id) > ($1.powerLevel, $1.rssi, $1.id) } )
            self.delegate?.reloadTableView()
        }
    }

    func smartScan(entered device: XYFinderDevice) {}
    func smartScan(status: XYSmartScanStatus) {}
    func smartScan(exiting device: XYBluetoothDevice) {}
    func smartScan(location: XYLocationCoordinate2D) {}
    func smartScan(detected device: XYFinderDevice, signalStrength: Int, family: XYFinderDeviceFamily) {}
    func smartScan(exited device: XYFinderDevice) {}
}
