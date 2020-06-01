//
//  StringExtensions.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/1/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

extension String {
    func isLink() -> Bool {
        return isType(type: .link)
    }
    
    func isPhoneNumber() -> Bool {
        return isType(type: .phoneNumber)
    }
    
    //not working well
    func isAddress() -> Bool {
        return isType(type: .address)
    }
    
    func isBase64Image() -> Bool {
        
        //TODO: check
        
        
        return false
    }
    
    
    func isType(type: NSTextCheckingResult.CheckingType) -> Bool {
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
