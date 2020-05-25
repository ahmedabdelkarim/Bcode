//
//  ScanDetailsViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/9/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class ScanDetailsViewController: UIViewController {
    @IBOutlet weak var barcodeTextLabel: UILabel!
    
    var barcodeText:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barcodeTextLabel.text = barcodeText
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
