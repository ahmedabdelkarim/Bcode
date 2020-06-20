//
//  UISegmentedControlExtensions.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/28/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setCustomStyle() {
        #if TARGET_INTERFACE_BUILDER
        //don't load in IB to avoid crash
        #else
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "ThemeColor1")!], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .highlighted)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "ThemeColor2")!], for: .selected)
        #endif
    }
}
