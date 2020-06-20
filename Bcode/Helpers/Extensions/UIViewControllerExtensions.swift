//
//  UIViewControllerExtensions.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func scrollToTop() {}
    
    func viewAnimating() {
        self.view.alpha = 0.85
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1
        })
    }
}
