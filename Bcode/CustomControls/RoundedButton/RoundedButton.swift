//
//  RoundedButton.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/26/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    //MARK: - Attributes
    /// rounding amount. 1 is a circle curve. 0 is no curve.
    @IBInspectable var rounding: CGFloat = 1.0 {
        didSet {
            if(rounding < 0) {
                rounding = 0
            }
            if(rounding > 1) {
                rounding = 1
            }
            
            updateCornerRadiusStyle()
        }
    }
    
    @IBInspectable var pressedColor: UIColor = UIColor.black
    
    @IBInspectable var disabledColor: UIColor = UIColor.lightGray
    
    @IBInspectable override var borderWidth: CGFloat {
        didSet {
            updateBorderStyle()
        }
    }
    
    @IBInspectable override var borderColor: UIColor? {
        didSet {
            updateBorderStyle()
        }
    }
    
    
    //MARK: - Variables
    private var normalColor: UIColor!
    
    
    //MARK: - Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateStyles()
    }
    
    
    //MARK: - Functions
    /// initialize control when loaded (called once)
    func initControl() {
        initStyles()
        handleInteractions()
    }
    
    func initStyles() {
        self.clipsToBounds = true
    }
    
    func updateStyles() {
        updateCornerRadiusStyle()
        updateBorderStyle()
    }
    
    func updateCornerRadiusStyle() {
        self.layer.cornerRadius =  self.layer.frame.height * (rounding / 2)
    }
    
    func updateBorderStyle() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
    func handleInteractions() {
        normalColor = self.backgroundColor
        self.addTarget(self, action: #selector(setPressedStyle), for: .touchDown)
        self.addTarget(self, action: #selector(setPressedStyle), for: .touchDragEnter)
        self.addTarget(self, action: #selector(setNormalStyle), for: .touchUpInside)
        self.addTarget(self, action: #selector(setNormalStyle), for: .touchDragExit)
    }
    
    @objc func setPressedStyle() {
        self.backgroundColor = pressedColor
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            //self.titleLabel?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }
    
    @objc func setNormalStyle() {
        self.backgroundColor = normalColor
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            //self.titleLabel?.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
