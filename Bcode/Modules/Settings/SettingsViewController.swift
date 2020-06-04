//
//  SettingsViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var vibrationEnabledSwitch: UISwitch!
    @IBOutlet weak var autoScanSwitch: UISwitch!
    @IBOutlet weak var multipleScansSwitch: UISwitch!
    @IBOutlet weak var syncToiCloudSwitch: UISwitch!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
        multipleScansSwitch.isEnabled = autoScanSwitch.isOn
    }
    
    //MARK: - Functions
    func loadSettings() {
        vibrationEnabledSwitch.isOn = Settings.vibrationEnabled
        autoScanSwitch.isOn = Settings.autoScan
        multipleScansSwitch.isOn = Settings.multipleScans
        syncToiCloudSwitch.isOn = Settings.syncToiCloud
    }
    
    override func scrollToTop() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switch sender {
        case vibrationEnabledSwitch:
            Settings.vibrationEnabled = sender.isOn
            break
        case autoScanSwitch:
            Settings.autoScan = sender.isOn
            multipleScansSwitch.isEnabled = sender.isOn
            
            if(Settings.autoScan == false) {
                Settings.multipleScans = false
                multipleScansSwitch.isOn = false
            }
            break
        case multipleScansSwitch:
            Settings.multipleScans = sender.isOn
            break
        case syncToiCloudSwitch:
            Settings.syncToiCloud = sender.isOn
            break
        default:
            break
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        BarcodeActions.openLink(link: "https://www.facebook.com/ahmed.karim.tantawy")
    }
    
    @IBAction func linkedinTapped(_ sender: Any) {
        BarcodeActions.openLink(link: "https://www.linkedin.com/in/ahmedabdelkarim")
    }
    
    @IBAction func websiteTapped(_ sender: Any) {
        BarcodeActions.openLink(link: "https://ahmedabdelkarim.wordpress.com/")
    }
}
