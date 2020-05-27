//
//  ScanDetailsViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/9/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class ScanDetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var barcodeTextLabel: UILabel!
    
    //MARK: - Variables
    var barcodeText:String!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        showBarcodeText()
        displayProperActions()
    }
    
    //MARK: - Functions
    func showBarcodeText() {
        barcodeTextLabel.text = barcodeText
        //TODO: show thumbnails if needed (image if base64 image, map, phone nnumber indicator, web page or link, etc.)
        
    }
    
    func displayProperActions() {
        //TODO: show/hide actions based on detected barcode text
    }

    //MARK: - Actions
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyTextButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = "\(barcodeText!)\nDetected by Bcode - app url"
        //TODO: show animated checkmark to confirm copied
        
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func openUrlButtonClicked(_ sender: Any) {
        if let url = URL(string: barcodeText) {
            UIApplication.shared.open(url)
        }
        else {
            //TODO: show cannot open url
        }
    }
    
    @IBAction func phoneCallButtonClicked(_ sender: Any) {
        if let url = URL(string: "tel://" + barcodeText) {
            UIApplication.shared.open(url)
        }
        else {
            //TODO: show cannot call number
        }
    }
    
    @IBAction func openInMapsButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func openImageButtonClicked(_ sender: Any) {
        
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


//MARK: - UIActivityItemSource
extension ScanDetailsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "\(barcodeText!)\nDetected by Bcode - app url"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "\(barcodeText!)\nDetected by Bcode - app url"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Detected by Bcode"
    }
}
