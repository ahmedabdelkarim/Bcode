//
//  Settings.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/30/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

class Settings {
    //MARK: - Variables
    private static let defaults = UserDefaults.standard
    
    //MARK: - Properties
    static var vibrationEnabled:Bool {
        get {
            return defaults.bool(forKey: "vibrationEnabled")
        }
        set {
            defaults.set(newValue, forKey: "vibrationEnabled")
        }
    }
    
    static var autoScan:Bool {
        get {
            return defaults.bool(forKey: "autoScan")
        }
        set {
            defaults.set(newValue, forKey: "autoScan")
        }
    }
    
    static var multipleScans:Bool {
        get {
            return defaults.bool(forKey: "multipleScans")
        }
        set {
            defaults.set(newValue, forKey: "multipleScans")
        }
    }
    
    static var syncToiCloud:Bool {
        get {
            return defaults.bool(forKey: "syncToiCloud")
        }
        set {
            defaults.set(newValue, forKey: "syncToiCloud")
        }
    }
}
