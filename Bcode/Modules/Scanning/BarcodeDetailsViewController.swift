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
    @IBOutlet weak var barcodeDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: RoundedButton!
    
    @IBOutlet weak var imageButton: RoundedButton!
    @IBOutlet weak var mapLocationButton: RoundedButton!
    @IBOutlet weak var phoneNumberButton: RoundedButton!
    @IBOutlet weak var linkButton: RoundedButton!
    
    //MARK: - Variables
    var barcodeInfo:BarcodeInfo!
    var delegate:BarcodeDetailsViewControllerDelegate?
    private var isDeleted:Bool = false
    private var isFavoriteChanged:Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        showBarcodeDetails()
        setFavoriteButtonImage()
        displayProperActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate?.barcodeDetailsDismissed(viewController: self, barcodeInfo: self.barcodeInfo, isDeleted: self.isDeleted, isFavoriteChanged: self.isFavoriteChanged)
    }
    
    //MARK: - Functions
    func showBarcodeDetails() {
        barcodeTextLabel.text = barcodeInfo.text
        
        barcodeDateLabel.text = barcodeInfo.date.formattedString
        
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
        //show/hide actions based on barcodeInfo.contentType
        switch barcodeInfo.contentType {
        case .link:
            linkButton.isHidden = false
            break
        case .phoneNumber:
            phoneNumberButton.isHidden = false
            break
        case .mapLocation:
            mapLocationButton.isHidden = false
            break
        case .image:
            imageButton.isHidden = false
            break
        default:
            break
        }
    }

    //MARK: - Actions
    @IBAction func deleteButtonClicked(_ sender: Any) {
        barcodeInfo.delete()
        isDeleted = true
        dismiss(animated: true)
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func favoriteButtonClick(_ sender: Any) {
        if(barcodeInfo.isFavorite) {
            barcodeInfo.unfavorite()
        }
        else {
            barcodeInfo.favorite()
        }
        
        setFavoriteButtonImage()
        isFavoriteChanged = true
    }
    
    @IBAction func copyTextButtonClicked(_ sender: Any) {
        Actions.copyToClipboard(text: barcodeInfo.text)

        //TODO: show animated checkmark to confirm copied
        
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func openLinkButtonClicked(_ sender: Any) {
        Actions.openLink(link: barcodeInfo.text)
    }
    
    @IBAction func phoneCallButtonClicked(_ sender: Any) {
        Actions.callNumber(number: barcodeInfo.text)
    }
    
    @IBAction func openInMapsButtonClicked(_ sender: Any) {
        Actions.openMapLocation(location: barcodeInfo.text)
    }
    
    @IBAction func openImageButtonClicked(_ sender: Any) {
        Actions.openImage(image: barcodeInfo.text)
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

protocol BarcodeDetailsViewControllerDelegate {
    func barcodeDetailsDismissed(viewController: BarcodeDetailsViewController, barcodeInfo: BarcodeInfo, isDeleted: Bool, isFavoriteChanged: Bool)
}
