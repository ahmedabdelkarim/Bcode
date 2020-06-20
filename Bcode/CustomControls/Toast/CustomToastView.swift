//
//  CustomToastView.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/18/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class CustomToastView: ToastView {
    //MARK: - Init
    convenience init(view: UIView) {
        self.init()
        self.innerView = view
        self.innerView.removeFromSuperview()
        calculateValues()
    }
    
    convenience init(view: UIView, width: CGFloat, height:CGFloat) {
        self.init()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.innerView = view
        self.innerView.removeFromSuperview()
        calculateValues()
    }
}
