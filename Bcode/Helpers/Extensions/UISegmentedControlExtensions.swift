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
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .highlighted)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}
