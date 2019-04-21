//
//  InfoPlistParser.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 17/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

struct InfoPlistParser {
    
    static func getStringValue(forKey: String) -> String {
        guard let value = Bundle.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key '\(forKey)' in the Info.plist file")
        }
        return value
    }
    
}
