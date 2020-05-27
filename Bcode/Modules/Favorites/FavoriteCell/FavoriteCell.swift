//
//  FavoriteCell.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var barcodeTextLabel: UILabel!
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Functions
    func setup(barcodeInfo:BarcodeInfo) {
        barcodeTextLabel.text = barcodeInfo.text
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
