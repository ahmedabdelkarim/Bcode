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
    
    /// Indicate if settings are stored on device. Used to make sure that settings are stored in first run for the app.
    private static var defaultSettingsStored:Bool {
        get {
            return defaults.bool(forKey: "defaultSettingsStored")
        }
        set {
            defaults.set(newValue, forKey: "defaultSettingsStored")
        }
    }
    
    /// Version of settings, used to update settings and default values in future app versions.
    private static let currentSettingsVersion = "1"
    private static var settingsVersion:String {
        get {
            return defaults.string(forKey: "settingsVersion") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "settingsVersion")
        }
    }
    
    //MARK: - Functions
    static func setDefaults() {
        if(Settings.defaultSettingsStored == false) {
            Settings.vibrationEnabled = true
            Settings.autoScan = false
            Settings.continuousScan = false
            Settings.syncToiCloud = false
            
            Settings.defaultSettingsStored = true
        }
    }
    
    /// Used to reset settings based on user action (ex: reset button) to reset to default values of current settings version.
    static func resetSettings() {
        Settings.defaultSettingsStored = false
        setDefaults()
    }
    
    static func resetSettingsWhenVersionChanged() {
        if(Settings.settingsVersion != Settings.currentSettingsVersion) {
            resetSettings()
            Settings.settingsVersion = Settings.currentSettingsVersion
        }
    }
    
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
    
    static var continuousScan:Bool {
        get {
            return defaults.bool(forKey: "continuousScan")
        }
        set {
            defaults.set(newValue, forKey: "continuousScan")
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
