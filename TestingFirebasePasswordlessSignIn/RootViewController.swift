//
//  RootViewController.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints
import FirebaseAuth

class RootViewController: UIViewController {
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    var hud = Hud.create()
    
    lazy var signInSignOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(signInSignOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func signInSignOutButtonTapped() {
        switch Service.authState {
        case .signedIn:
            signOut()
        case .signedOut:
            gotToSignInViewController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                print("User is nil.")
                self.navigationItem.title = "Profile"
                Service.authState = .signedOut
                self.signInSignOutButton.setTitle("Sign In", for: .normal)
            }
            if let user = user, let email = user.email {
                print("Found User with email: \(email)")
                self.navigationItem.title = email
                Service.authState = .signedIn
                self.signInSignOutButton.setTitle("Sign Out", for: .normal)
            }
        }
        
        if Setup.shouldOpenMailApp {
            Setup.shouldOpenMailApp = false
            if let url = URL(string: "message://") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    UIAlertService.showAlert(style: .alert, title: "Error", message: "Could not open Mail app")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle else { return }
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }

    fileprivate func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        
        view.addSubview(signInSignOutButton)
        
        signInSignOutButton.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(top: 36, left: 12, bottom: 0, right: 12), usingSafeArea: true)
        signInSignOutButton.height(50)
    }
    
    fileprivate func signOut() {
        let detailText = "Signing out..."
        Hud.handle(hud, with: HudInfo(type: .show, text: "Working", detailText: detailText))
        let auth = Auth.auth()
        do {
            try auth.signOut()
            Hud.handle(hud, with: HudInfo(type: .success, text: "Success", detailText: detailText))
        } catch let err {
            Hud.handle(hud, with: HudInfo(type: .error, text: "Error", detailText: err.localizedDescription))
        }
    }
    
    fileprivate func gotToSignInViewController() {
        let controller = SignInViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

