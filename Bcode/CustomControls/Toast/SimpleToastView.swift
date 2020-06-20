//
//  SimpleToastView.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/18/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class SimpleToastView: ToastView {
    //MARK: - Variables
    var title: String!
    var backgroundView:UIView!
    var titleLabel:UILabel!
    
    //MARK: - Init
    init(title: String, background:UIColor = .black, foreground:UIColor = .white) {
        super.init(frame: CGRect())
        
        self.title = title
        
        backgroundView = UIView()
        backgroundView.clipsToBounds = true
        backgroundView.backgroundColor = background
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = foreground
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        self.innerView = backgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    static func show(title:String, background:UIColor = .black, foreground:UIColor = .white) {
        let toast = CustomToastView(view: buildView(title:title, background: background, foreground: foreground))
        toast.show()
    }
    
    override func show(shown: (() -> Void)? = nil, hidden: (() -> Void)? = nil) {
        self.innerView = SimpleToastView.buildView(backgroundView: backgroundView, titleLabel: titleLabel, title: self.title)
        calculateValues()
        super.show(shown: shown, hidden: hidden)
    }
    
    //MARK: - Help Functions
    static func buildView(backgroundView:UIView? = nil, titleLabel:UILabel? = nil, title:String, background:UIColor = .black, foreground:UIColor = .white) -> UIView {
        //background view
        var view:UIView!
        if(backgroundView != nil) {
            view = backgroundView
        }
        else {
            view = UIView()
            view.clipsToBounds = true
            view.backgroundColor = background
        }
        
        //label
        var label:UILabel!
        if(titleLabel != nil) {
            label = titleLabel
        }
        else {
            label = UILabel()
            label.text = title
            label.textColor = foreground
            label.textAlignment = .center
            label.numberOfLines = 0
            //label.backgroundColor = .red//for testing
        }
        
        //view constraints
        let maxWidth = UIScreen.main.bounds.width - 32
        let maxHeight = maxWidth/2
        let minHeight:CGFloat = 40
        view.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        view.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        
        //dynamic label height
        let maxLabelWidth = maxWidth - maxHeight
        let calculatedLabelSize = label.sizeThatFits(CGSize(width: maxLabelWidth, height: maxHeight))
        label.sizeToFit()
        var labelFrame = label.frame
        labelFrame.size.height = calculatedLabelSize.height
        label.frame = labelFrame
        
        let viewHeight = min(maxHeight, label.bounds.height + 4)
        let viewWidth = min(maxWidth, label.bounds.width + max(viewHeight, minHeight))
        
        //label constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: max(viewHeight, minHeight)/2 - 2).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(max(viewHeight, minHeight)/2 - 2)).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
        
        //set frame
        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: max(viewHeight, minHeight))
        view.layer.cornerRadius = view.frame.height/2
        
        return view
    }
}
