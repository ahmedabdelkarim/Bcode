//
//  Behaviors.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/30/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import AVFoundation

class Behaviors {
    static func vibrate() {
        if(Settings.vibrationEnabled) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
}
