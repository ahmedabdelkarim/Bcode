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
    
    static func openLink(link:String, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        if var url = URL(string: link) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if (components?.scheme == nil) {
                components?.scheme = "http"
            }
            
            url = components?.url ?? url
            
            UIApplication.shared.open(url, options: [:], completionHandler: {(done) in
                done ? success?() : failed?()
            })
        }
        else {
            //TODO: show cannot open url in calls
            failed?()
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
