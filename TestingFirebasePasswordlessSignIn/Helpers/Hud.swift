//
//  Hud.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
import JGProgressHUD

enum HudType {
    case none
    case show
    case update
    case success
    case error
}

struct HudInfo {
    let type: HudType
    let text: String
    let detailText: String
}

class Hud {
    
    // MARK: -
    // MARK: Handle hud
    
    static func handle(_ hud: JGProgressHUD, with info: HudInfo) {
        switch info.type {
        case .none:
            return
        case .show:
            show(hud, text: info.text, detailText: info.detailText)
        case .update:
            change(hud, text: info.text, detailText: info.detailText)
        case .success:
            dismiss(hud, type: info.type, text: info.text, detailText: info.detailText)
        case .error:
            dismiss(hud, type: info.type, text: info.text, detailText: info.detailText)
        }
    }
    
    // MARK: -
    // MARK: Create hud
    
    static func create() -> JGProgressHUD {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }
    
    // MARK: -
    // MARK: Show hud
    
    static func show(_ hud: JGProgressHUD, text: String, detailText: String = "") {
        hud.textLabel.text = text
        if detailText != "" {
            hud.detailTextLabel.text = detailText
        }
        if let topVC = UIApplication.getTopMostViewController() {
            hud.show(in: topVC.view)
        }
    }
    
    // MARK: -
    // MARK: Change hud
    
    static func change(_ hud: JGProgressHUD, text: String, detailText: String = "") {
        hud.textLabel.text = text
        if detailText != "" {
            hud.detailTextLabel.text = detailText
        }
    }
    
    // MARK: -
    // MARK: Dismiss hud
    
    static func dismiss(_ hud: JGProgressHUD, type: HudType, text: String, detailText: String) {
        DispatchQueue.main.async {
            hud.textLabel.text = text
            hud.detailTextLabel.text = detailText
            let delay = type == .success ? TimeInterval(0.5) : TimeInterval(1.0)
            hud.dismiss(afterDelay: delay , animated: true)
        }
    }
    
}

