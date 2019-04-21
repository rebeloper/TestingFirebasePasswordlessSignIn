//
//  Service.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import FirebaseAuth

enum AuthState {
    case signedIn
    case signedOut
}

struct Service {
    static var authState: AuthState = .signedOut
}
