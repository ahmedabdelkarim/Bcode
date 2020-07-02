//
//  HistoryCell.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var mainActionButton: RoundedButton!
    @IBOutlet weak var barcodeTextLabel: UILabel!
    @IBOutlet weak var isFavoriteImageView: UIImageView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    //MARK: - Variables
    private var barcodeInfo:BarcodeInfo!

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(named: "ThemeColor1")
        self.selectedBackgroundView = backgroundView
    }

    //MARK: - Functions
    func setup(barcodeInfo:BarcodeInfo) {
        self.barcodeInfo = barcodeInfo
        
        mainActionButton.setImage(barcodeInfo.actionImage, for: .normal)
        barcodeTextLabel.text = barcodeInfo.text
        isFavoriteImageView.isHidden = !barcodeInfo.isFavorite
        timeAgoLabel.text = barcodeInfo.date.timeAgo
    }
    
    //MARK: - Actions
    @IBAction func mainActionButtonClick(_ sender: Any) {
        barcodeInfo.performMainAction()
    }
}
