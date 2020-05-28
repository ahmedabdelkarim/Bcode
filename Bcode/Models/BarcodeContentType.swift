//
//  BarcodeContentType.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/28/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

enum BarcodeContentType:String {
    case text = "Text"
    case url = "URL"
    case phoneNumber = "Phone Number"
    case mapLocation = "Map Location"
    case image = "Image"
    
    public var image:UIImage? {
        get {
            switch self {
            case .text:
                return UIImage(systemName: "textformat.abc")
            case .url:
                return UIImage(systemName: "safari.fill")
            case .phoneNumber:
                return UIImage(systemName: "phone.fill")
            case .mapLocation:
                return UIImage(systemName: "map.fill")
            case .image:
                return UIImage(systemName: "photo.fill")
            }
        }
    }
}
