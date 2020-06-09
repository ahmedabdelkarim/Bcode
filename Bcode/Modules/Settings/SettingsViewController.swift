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
    @IBOutlet weak var continuousScanSwitch: UISwitch!
    @IBOutlet weak var syncToiCloudSwitch: UISwitch!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
        continuousScanSwitch.isEnabled = autoScanSwitch.isOn
    }
    
    //MARK: - Functions
    func loadSettings() {
        vibrationEnabledSwitch.isOn = Settings.vibrationEnabled
        autoScanSwitch.isOn = Settings.autoScan
        continuousScanSwitch.isOn = Settings.continuousScan
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
            continuousScanSwitch.isEnabled = sender.isOn
            
            if(Settings.autoScan == false) {
                Settings.continuousScan = false
                continuousScanSwitch.isOn = false
            }
            break
        case continuousScanSwitch:
            Settings.continuousScan = sender.isOn
            break
        case syncToiCloudSwitch:
            Settings.syncToiCloud = sender.isOn
            break
        default:
            break
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        Actions.openLink(link: "fb://profile/100003149322410", failed: {
            Actions.openLink(link: "https://www.facebook.com/ahmed.karim.tantawy")
        })
    }
    
    @IBAction func linkedinTapped(_ sender: Any) {
        Actions.openLink(link: "https://www.linkedin.com/in/ahmedabdelkarim")
    }
    
    @IBAction func websiteTapped(_ sender: Any) {
        Actions.openLink(link: "https://ahmedabdelkarim.wordpress.com")
    }
}
