//
//  Dialogs.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/8/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class Dialogs {
    static func showDialog(viewController:UIViewController, title: String, message: String? = nil, buttonTitle: String? = "OK", completion: @escaping () -> Void = {  }) {
        if viewController.navigationController?.presentedViewController == nil {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in completion() }))
            alert.view.tintColor = UIColor(named: "ThemeColor1")
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showConfirmationDialog(viewController:UIViewController, question: String, message: String? = nil, action1Title: String? = nil, action1Style:UIAlertAction.Style = .default, action2Title: String? = nil, action2Style:UIAlertAction.Style = .default, action3Title: String? = nil, action3Style:UIAlertAction.Style = .default, action1Selected: (() -> Void)? = nil, action2Selected: (() -> Void)? = nil, action3Selected: (() -> Void)? = nil) {
        let alert = UIAlertController(title: question, message: message, preferredStyle: .alert)
        
        if(action1Title != nil) {
            alert.addAction(UIAlertAction(title: action1Title, style: action1Style, handler: { action in action1Selected?() }))
        }
        
        if(action2Title != nil) {
            alert.addAction(UIAlertAction(title: action2Title, style: action2Style, handler: { action in action2Selected?() }))
        }
        
        if(action3Title != nil) {
            alert.addAction(UIAlertAction(title: action3Title, style: action3Style, handler: { action in action3Selected?() }))
        }
        
        alert.view.tintColor = UIColor(named: "ThemeColor1")
        viewController.present(alert, animated: true, completion: nil)
    }
}
