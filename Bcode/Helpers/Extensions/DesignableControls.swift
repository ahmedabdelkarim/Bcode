//
//  DesignableControls.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class DesignableView: UIView {
    
}

class DesignableSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        setCustomStyle()
    }
}
