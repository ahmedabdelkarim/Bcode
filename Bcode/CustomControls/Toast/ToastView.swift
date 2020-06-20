//
//  ToastView.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/18/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ToastView: UIView {
    //MARK: - Properties
    @IBInspectable var autoHide:Bool = true
    @IBInspectable var showInterval:TimeInterval = 0.5
    @IBInspectable var hideInterval:TimeInterval = 0.5
    @IBInspectable var enterWithFade:Bool = true
    @IBInspectable var exitWithFade:Bool = true
    @IBInspectable var autoHideInterval:TimeInterval = 3.0
    @IBInspectable var edge:ToastEdge = .top {
        didSet {
            calculateValues()
        }
    }
    
    //TODO: rename: horizontal & vertical Displacement, use to set x and y for start position and movement
    /// Value from 0 to 1 represents percent of screen width (for left and right edge) or height (for top and bottom edge).
    @IBInspectable var insets:UIEdgeInsets = UIEdgeInsets(top: 0.02, left: 0.04, bottom: 0.02, right: 0.04) {
        didSet {
            calculateValues()
        }
    }
    @IBInspectable var appearanceStyle:ToastAppearanceStyle = .fade
    
    //MARK: - Variables
    open var keyWindow:UIWindow!
    open var innerView:UIView!
    private var startPosition:CGPoint!
    private var startPositionInset = CGFloat(integerLiteral: 12)
    private var movement:CGPoint!
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        innerView = self
        self.innerView.removeFromSuperview()
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        #if TARGET_INTERFACE_BUILDER
        //don't load in IB to avoid crash
        #else
        keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        calculateValues()
        #endif
    }
    
    //MARK: - Functions
    open func show(shown: (() -> Void)? = nil, hidden: (() -> Void)? = nil) {
        keyWindow.addSubview(innerView)
        
        switch self.appearanceStyle {
        case .enter:
            self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
            break
        case .fade:
            self.innerView.alpha = 0
            self.innerView.transform = CGAffineTransform(translationX: self.movement.x, y: self.movement.y)
            break
        case .enterWithFade:
            self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.innerView.alpha = 0
            break
        }
        
        UIView.animate(withDuration: showInterval, animations: {
            switch self.appearanceStyle {
            case .enter:
                self.innerView.transform = CGAffineTransform(translationX: self.movement.x, y: self.movement.y)
                break
            case .fade:
                self.innerView.alpha = 1
                break
            case .enterWithFade:
                self.innerView.transform = CGAffineTransform(translationX: self.movement.x, y: self.movement.y)
                self.innerView.alpha = 1
                break
            }
        }, completion: { (finished) in
            shown?()
            
            if(self.autoHide) {
                UIView.animate(withDuration: self.hideInterval, delay: self.autoHideInterval, options: [], animations: {
                    switch self.appearanceStyle {
                    case .enter:
                        self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
                        break
                    case .fade:
                        self.innerView.alpha = 0
                        break
                    case .enterWithFade:
                        self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.innerView.alpha = 0
                        break
                    }
                }, completion: { (finished) in
                    self.innerView.removeFromSuperview()
                    hidden?()
                })
            }
        })
    }
    
    open func hide(hidden: (() -> Void)? = nil) {
        if(self.autoHide == false) {
            UIView.animate(withDuration: self.hideInterval, delay: 0, options: [], animations: {
                switch self.appearanceStyle {
                case .enter:
                    self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
                    break
                case .fade:
                    self.innerView.alpha = 0
                    break
                case .enterWithFade:
                    self.innerView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.innerView.alpha = 0
                    break
                }
            }, completion: { (finished) in
                hidden?()
            })
        }
    }
    
    //MARK: - Help Functions
    open func calculateValues() {
        switch edge {
        case .top:
            let topPadding = (keyWindow?.safeAreaInsets.top)!
            
            startPosition = CGPoint(x: UIScreen.main.bounds.size.width/2 - innerView.bounds.width/2, y: -innerView.bounds.height - startPositionInset)
            movement = CGPoint(x: 0, y: innerView.bounds.height + topPadding + startPositionInset + insets.top * UIScreen.main.bounds.size.height)
            break
        case .bottom:
            let bottomPadding = (keyWindow?.safeAreaInsets.bottom)!
            
            startPosition = CGPoint(x: UIScreen.main.bounds.size.width/2 - innerView.bounds.width/2, y: UIScreen.main.bounds.size.height + startPositionInset)
            movement = CGPoint(x: 0, y: -innerView.bounds.height - bottomPadding - startPositionInset - insets.bottom * UIScreen.main.bounds.size.height)
            break
        case .left:
            startPosition = CGPoint(x: -innerView.bounds.width - startPositionInset, y: UIScreen.main.bounds.size.height/2 - innerView.bounds.height/2)
            movement = CGPoint(x: innerView.bounds.width + startPositionInset + insets.left * UIScreen.main.bounds.size.width, y: 0)
            break
        case .right:
            startPosition = CGPoint(x: UIScreen.main.bounds.size.width + startPositionInset, y: UIScreen.main.bounds.size.height/2 - innerView.bounds.height/2)
            movement = CGPoint(x: -innerView.bounds.width - startPositionInset - insets.right * UIScreen.main.bounds.size.width, y: 0)
            break
        default:
            break
        }
        
        innerView.frame = CGRect(x: startPosition.x, y: startPosition.y, width: innerView.bounds.width, height: innerView.bounds.height)
    }
}
