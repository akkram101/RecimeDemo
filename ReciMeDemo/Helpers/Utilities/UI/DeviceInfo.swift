//
//  DeviceInfo.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import UIKit

struct DeviceInfo {
    static func currentModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?
            .trimmingCharacters(in: .controlCharacters) ?? "Unknown"
    }
    
    static func isSimulator() -> Bool {
        return currentModelIdentifier() == "x86_64" || currentModelIdentifier() == "arm64"
    }
    
    private static func isDeviceInList(_ identifiers: [String]) -> Bool {
        let model = currentModelIdentifier()
        
        if isSimulator() {
            if let simModel = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return identifiers.contains(simModel)
            }
        }
        
        return identifiers.contains(model)
    }
    
    static func isIphoneSE() -> Bool {
        let iphoneSEIdentifiers = ["iPhone8,4", "iPhone12,8", "iPhone14,6"]
        return isDeviceInList(iphoneSEIdentifiers)
    }
    
    static func isIphonePro() -> Bool {
        let supportedIdentifiers = [
            "iPhone12,3",   // iPhone 11 Pro
            "iPhone13,3",   // iPhone 12 Pro
            "iPhone14,2",   // iPhone 13 Pro
            "iPhone15,3",   // iPhone 14 Pro
            "iPhone16,3",   // iPhone 15 Pro
            "iPhone17,3"    // iPhone 17 Pro
        ]
        return isDeviceInList(supportedIdentifiers)
    }

    
    static func getDeviceInfo() -> (deviceModel: String, UDID: String, osName: String, osVersion: String, deviceType: String, screenResolution: String, appVersion: String) {
        let device = UIDevice.current
        let deviceModel = getDeviceName()
        let udid = UUID().uuidString
        let osName = device.systemName
        let osVersion = device.systemVersion
        
        let deviceType: String
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            deviceType = "Mobile"
        case .pad:
            deviceType = "Tablet"
        default:
            deviceType = "Unknown"
        }
        
        let screenSize = UIScreen.main.bounds
        let screenResolution = "\(Int(screenSize.width)) x \(Int(screenSize.height))"
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
        
        return (deviceModel, udid, osName, osVersion, deviceType, screenResolution, appVersion)
    }
    
    
    static func getDeviceName() -> String {
        let identifier = currentModelIdentifier()
        
        if identifier == "arm64" || identifier == "x86_64" {
            return "Simulator"
        }
        
        switch identifier {
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,6": return "iPhone SE (3rd generation)"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone14,9": return "iPhone 14 Pro"
        case "iPhone14,10": return "iPhone 14 Pro Max"
        case "iPhone15,1": return "iPhone 15"
        case "iPhone15,2": return "iPhone 15 Plus"
        case "iPhone15,3": return "iPhone 15 Pro"
        case "iPhone15,4": return "iPhone 15 Pro Max"
        case "iPhone16,1": return "iPhone 16"
        case "iPhone16,2": return "iPhone 16 Plus"
        case "iPhone16,3": return "iPhone 16 Pro"
        case "iPhone16,4": return "iPhone 16 Pro Max"
        case "iPhone17,1": return "iPhone 17"
        case "iPhone17,2": return "iPhone 17 Plus"
        case "iPhone17,3": return "iPhone 17 Pro"
        case "iPhone17,4": return "iPhone 17 Pro Max"
        case "iPad8,1": return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,2": return "iPad Pro (11-inch) (1st generation)"
        default: return identifier
        }
    }
}
