//
//  AppDelegate.swift
//  TestingFirebasePasswordlessSignIn
//
//  Created by Alex Nagy on 03/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = RootViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
    }
    
    func handlePasswordlessSignIn(withUrl url: URL) -> Bool {
        let link = url.absoluteString
        if Auth.auth().isSignIn(withEmailLink: link) {
            
            guard let email = UserDefaults.standard.value(forKey: Setup.kEmail) as? String else {
                print("Error signing in: email does not exist")
                UIAlertService.showAlert(style: .alert, title: "Error", message: "Error signing in: email does not exist")
                return true
            }
            
            Auth.auth().signIn(withEmail: email, link: link) { (auth, err) in
                if let err = err {
                    print("Error signing in: \(err.localizedDescription)")
                    UIAlertService.showAlert(style: .alert, title: "Error", message: "Error signing in: \(err.localizedDescription)")
                    return
                }
                
                guard let auth = auth else {
                    print("Error signing in.")
                    UIAlertService.showAlert(style: .alert, title: "Error", message: "Error signing in")
                    return
                }
                
                let uid = auth.user.uid
                print("Successfully signed in user with uid: \(uid)")
                
                let data = [
                    "uid": uid,
                    "createdAt": FieldValue.serverTimestamp(),
                    "email": email
                    ] as [String : Any]
                
                Firestore.firestore().collection("users")
                    .document(uid).setData(data, completion: { (err) in
                        if let err = err {
                            print("Error saving user: \(err.localizedDescription)")
                            UIAlertService.showAlert(style: .alert, title: "Error", message: "Error saving user: \(err.localizedDescription)")
                            return
                        }
                        
                        print("Successfully saved to Firestore user with uid: \(uid)")
                        UIAlertService.showAlert(style: .alert, title: "Success", message: "You have successfully signed in with email: \(email)")
                    })
            }
            
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

