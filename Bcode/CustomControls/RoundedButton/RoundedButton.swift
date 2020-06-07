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
    
    @IBInspectable var pressedColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
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
        
        self.addTarget(self, action: #selector(setTappedStyle), for: .touchUpInside)
        
        //self.addTarget(self, action: #selector(setPressedStyle), for: .touchDown)
        
        self.addTarget(self, action: #selector(setNormalStyle), for: .touchCancel)
        
        //self.addTarget(self, action: #selector(setNormalStyle), for: .touchUpOutside)
        
        self.addTarget(self, action: #selector(setPressedStyle), for: .touchDragEnter)
        self.addTarget(self, action: #selector(setNormalStyle), for: .touchDragExit)
    }
    
    @objc func setPressedStyle() {
        self.backgroundColor = pressedColor
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            //self.titleLabel?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }
    
    @objc func setNormalStyle() {
        self.backgroundColor = normalColor
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            //self.titleLabel?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished:Bool) in
            self.updateCornerRadiusStyle()
        })
    }
    
    @objc func setTappedStyle() {
        self.backgroundColor = pressedColor
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            //self.titleLabel?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (finished: Bool) in
            self.setNormalStyle()
        })
    }
}
