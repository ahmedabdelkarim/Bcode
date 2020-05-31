//
//  ShortcutItemHandler.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 4/22/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class ShortcutItemHandler {
    public static var delegate:ShortcutItemHandlerDelegate?
    
    private static let scanQR = "ScanQR"
    private static let scanEAN13 = "ScanEAN13"
    private static let scanImage = "ScanImage"
    
    static func handle(_ shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case scanQR:
            delegate?.scanQR()
            break
        case scanEAN13:
            delegate?.scanEAN13()
            break
        case scanImage:
            delegate?.scanImage()
            break
        default:
            break
        }
    }
}

protocol ShortcutItemHandlerDelegate {
    func scanQR()
    func scanEAN13()
    func scanImage()
}
