//
//  SignInViewController.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var hud = Hud.create()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        return tf
    }()
    
    lazy var sendMagicLinkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Send Magic Link", for: .normal)
        button.addTarget(self, action: #selector(sendMagicLinkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func sendMagicLinkButtonTapped() {
        
        Hud.handle(hud, with: HudInfo(type: .show, text: "Working", detailText: "Sending email..."))
        
        // build the url
        let actionCodeSettings = ActionCodeSettings()
        
        let email = emailTextField.text ?? ""
        
        let scheme = InfoPlistParser.getStringValue(forKey: Setup.kFirebaseOpenAppScheme)
        let uriPrefix = InfoPlistParser.getStringValue(forKey: Setup.kFirebaseOpenAppURIPrefix)
        let queryItemEmailName = InfoPlistParser.getStringValue(forKey: Setup.kFirebaseOpenAppQueryItemEmailName)
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = uriPrefix
        
        let emailTypeQueryItem = URLQueryItem(name: queryItemEmailName, value: email)
        components.queryItems = [emailTypeQueryItem]
        
        guard let linkParameter = components.url else { return }
        print("Link Parameter: \(linkParameter.absoluteString)")
        
        actionCodeSettings.url = linkParameter
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { (err) in
            if let err = err {
                print(err.localizedDescription)
                Hud.handle(self.hud, with: HudInfo(type: .error, text: "Error", detailText: err.localizedDescription))
                return
            }
            print("Successfully sent sign in link")
            
            UserDefaults.standard.set(email, forKey: Setup.kEmail)
            
            Hud.handle(self.hud, with: HudInfo(type: .success, text: "Success", detailText: "Email sent!"))
            
            let openMailAppAction = UIAlertAction(title: "Open Mail App", style: .default, handler: { (action) in
                Setup.shouldOpenMailApp = true
                self.navigationController?.popViewController(animated: true)
            })
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            UIAlertService.showAlert(style: .alert, title: "Check your email", message: "We sent you a magic link to \"\(email)\". You can finish your sign in with it.", actions: [okAction, openMailAppAction], completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        
        view.addSubview(emailTextField)
        view.addSubview(sendMagicLinkButton)
        
        emailTextField.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(top: 24, left: 12, bottom: 0, right: 12), usingSafeArea: true)
        emailTextField.height(40)
        
        sendMagicLinkButton.topToBottom(of: emailTextField, offset: 24)
        sendMagicLinkButton.left(to: emailTextField)
        sendMagicLinkButton.right(to: emailTextField)
        sendMagicLinkButton.height(50)
    }
}
