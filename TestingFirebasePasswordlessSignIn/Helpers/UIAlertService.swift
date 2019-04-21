//
//  UIAlertService.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit

class UIAlertService {
    
    // MARK: -
    // MARK: Show alert
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        if let topVC = UIApplication.getTopMostViewController() {
            alert.popoverPresentationController?.sourceView = topVC.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            topVC.present(alert, animated: true, completion: completion)
        }
    }
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, textFields: [UITextField], completion: @escaping ([String]?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for textField in textFields {
            alert.addTextField(configurationHandler: { (theTextField) in
                theTextField.placeholder = textField.placeholder
            })
        }
        
        let textFieldAction = UIAlertAction(title: "Submit", style: .cancel) { (action) in
            var textFieldsTexts: [String] = []
            if let alertTextFields = alert.textFields {
                for textField in alertTextFields {
                    if let textFieldText = textField.text {
                        textFieldsTexts.append(textFieldText)
                    }
                }
                completion(textFieldsTexts)
            }
        }
        alert.addAction(textFieldAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            completion(nil)
        }
        alert.addAction(cancelAction)
        
        if let topVC = UIApplication.getTopMostViewController() {
            alert.popoverPresentationController?.sourceView = topVC.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}


