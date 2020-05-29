//
//  BarcodeDetailsViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/9/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class BarcodeDetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var barcodeTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: RoundedButton!
    
    //MARK: - Variables
    var barcodeInfo:BarcodeInfo!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        showBarcodeText()
        setFavoriteButtonImage()
        displayProperActions()
    }
    
    //MARK: - Functions
    func showBarcodeText() {
        barcodeTextLabel.text = barcodeInfo.text
        //TODO: show thumbnails if needed (image if base64 image, map, phone nnumber indicator, web page or link, etc.)
        
    }
    
    func setFavoriteButtonImage() {
        if(barcodeInfo.isFavorite) {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func displayProperActions() {
        //TODO: show/hide actions based on barcodeInfo.contentType
    }

    //MARK: - Actions
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonClick(_ sender: Any) {
        barcodeInfo.isFavorite = !barcodeInfo.isFavorite
        
        //TODO: save object in device data
        
        setFavoriteButtonImage()
    }
    
    @IBAction func copyTextButtonClicked(_ sender: Any) {
        BarcodeActions.copyToClipboard(text: barcodeInfo.text)

        //TODO: show animated checkmark to confirm copied
        
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func openUrlButtonClicked(_ sender: Any) {
        BarcodeActions.openLink(link: barcodeInfo.text)
    }
    
    @IBAction func phoneCallButtonClicked(_ sender: Any) {
        BarcodeActions.callNumber(number: barcodeInfo.text)
    }
    
    @IBAction func openInMapsButtonClicked(_ sender: Any) {
        BarcodeActions.openMapLocation(location: barcodeInfo.text)
    }
    
    @IBAction func openImageButtonClicked(_ sender: Any) {
        BarcodeActions.openImage(image: barcodeInfo.text)
    }
}


//MARK: - UIActivityItemSource
extension BarcodeDetailsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "\(barcodeInfo.text!)\nDetected by Bcode - app url"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "\(barcodeInfo.text!)\nDetected by Bcode - app url"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Detected by Bcode"
    }
}
