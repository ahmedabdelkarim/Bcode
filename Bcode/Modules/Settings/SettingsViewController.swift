//
//  SettingsViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var scrollView:UIScrollView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Functions
    
    
    override func scrollToTop() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    

}
