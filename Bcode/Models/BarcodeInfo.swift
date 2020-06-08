//
//  BarcodeInfo.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class BarcodeInfo {
    var text:String!
    var contentType:BarcodeContentType!
    var isFavorite:Bool!
    
    init(text:String, contentType:BarcodeContentType, isFavorite:Bool) {
        self.text = text
        self.contentType = contentType
        self.isFavorite = isFavorite
    }
    
    public var actionImage:UIImage? {
        get {
            return contentType.actionImage
        }
    }
    
    public func performMainAction() {
        contentType.performMainAction(text: text)
    }
    
    
    
    //database functions here
    
    
    static func getAllFromDatabase() {
        
    }
    
    static func deleteAllFromDatabase() {
        
    }
    
    func addToHistory() {
        
    }
    
    func favorite() {
        
    }
    
    func unfavorite() {
        
    }
    
    func deleteFromDatabase() {
        
    }
    
    
}
