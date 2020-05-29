//
//  BarcodeActions.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class BarcodeActions {
    static func copyToClipboard(text:String) {
        UIPasteboard.general.string = "\(text)\nDetected by Bcode - app url"
        
        //TODO: vibrate if enabled
        
        //TODO: show animated confirmation if possible
        
    }
    
    static func openLink(link:String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
        else {
            //TODO: show cannot open url
        }
    }
    
    static func callNumber(number:String) {
        if let url = URL(string: "tel://" + number) {
            UIApplication.shared.open(url)
        }
        else {
            //TODO: show cannot call number
        }
    }
    
    static func openMapLocation(location:String) {
        
    }
    
    static func openImage(image:String) {
        
    }
}
