//
//  StringExtensions.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/1/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        return false
    }
    
    //TODO: need to know if text has scheme, or not
    func isPhoneNumber() -> Bool {
        return isOfType(type: .phoneNumber)
    }
    
    func isSMS() -> Bool {
        return false
    }
    
    func isFaceTimeVideo() -> Bool {
        return false
    }
    
    func isFaceTimeAudio() -> Bool {
        return false
    }
    
    func isGeolocation() -> Bool {
        return false
    }
    
    func isLink() -> Bool {
        return isOfType(type: .link)
    }
    
    func isDate() -> Bool {
        return isOfType(type: .date)
    }
    
    //TODO: remove
    func isBase64Image() -> Bool {
        return false
    }
    
    
    private func isOfType(type: NSTextCheckingResult.CheckingType) -> Bool {
        do {
            let detector = try NSDataDetector(types: type.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            if let firstMatch = matches.first {
                return firstMatch.resultType == type && firstMatch.range.location == 0 && firstMatch.range.length == self.count
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
}
