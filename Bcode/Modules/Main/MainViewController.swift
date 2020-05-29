//
//  MainViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    //MARK: - Variables
    var previousController:UIViewController? = nil
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self;
    }

    //MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (previousController == viewController) {// the same tab was tapped a second time
            viewController.scrollToTop()
        }
        
        previousController = viewController
    }
}
