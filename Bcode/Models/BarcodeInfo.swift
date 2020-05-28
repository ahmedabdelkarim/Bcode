//
//  BarcodeInfo.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

class BarcodeInfo {
    var text:String!
    var contentType:BarcodeContentType!
    var isFavorite:Bool!
    
    init(text:String, contentType:BarcodeContentType, isFavorite:Bool) {
        self.text = text
        self.contentType = contentType
        self.isFavorite = isFavorite
    }
}
