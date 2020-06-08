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
    case link = "Link"
    case phoneNumber = "Phone Number"
    case mapLocation = "Map Location"
    case image = "Image"
    
    public var actionImage:UIImage? {
        get {
            switch self {
            case .text:
                return UIImage(systemName: "doc.on.doc.fill")
            case .link:
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
    
    public func performMainAction(text:String) {
        switch self {
        case .text:
            Actions.copyToClipboard(text: text)
        case .link:
            Actions.openLink(link: text)
        case .phoneNumber:
            Actions.callNumber(number: text)
        case .mapLocation:
            Actions.openMapLocation(location: text)
        case .image:
            Actions.openImage(image: text)
        }
    }
}
