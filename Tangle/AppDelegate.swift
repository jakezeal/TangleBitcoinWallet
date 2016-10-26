//
//  AppDelegate.swift
//  Tangle
//
//  Created by Jake on 8/5/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    
    var wallet: Wallet?
    
    // MARK: - App Delegate Methods
    /**
     @name  application:didFinishLaunchingWithOptions
     
     - parameter application:   UIApplication
     - parameter launchOptions: [NSObject: AnyObject]?
     
     - returns: Bool
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        prepareStartViewController()
        
        setupWalletBalanceNotifications()
        
        return true
    }
    
    /**
     @name  applicationDidBecomeActive
     
     - parameter application: UIApplication
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // TODO: Pull information from API based on stored keys and update balance
    }
    
    /**
     @name  application:shouldAllowExtensionPointIdentifier
     
     - parameter application:              UIApplication
     - parameter extensionPointIdentifier: String
     
     - returns: Bool
     */
    // Disable extensions such as custom keyboards for security purposes
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        return false
    }
    
    // MARK: - Helper Methods
    /**
     @name  changeRootViewController
     
     - parameter viewController: UIViewController
     */
    func changeRootViewController(_ viewController: UIViewController) {
        
        UIView.transition(with: window!,
                                  duration: 0.5,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.window?.rootViewController = viewController
            }, completion: nil)
        
        window?.makeKeyAndVisible()
    }
    
}

private extension AppDelegate {

    // MARK: - Preparations
    /**
     @name  prepareStartViewController
     */
    func prepareStartViewController() {
        
        let startViewController: UIViewController
    
        if false {
            // If it is the user's first time on application, show onboarding
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            startViewController = storyboard.instantiateViewController(withIdentifier: "RootOnboardingViewController") as! RootOnboardingViewController
        } else {
            // If it is not their first time on application, skip to WalletViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            
        }
        prepareWindow(startViewController)
    }
    
    /**
     @name  prepareWindow
     
     - parameter startViewController: UIViewController
     */
    func prepareWindow(_ startViewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = startViewController
        window?.makeKeyAndVisible()
    }
    
    /**
     @name  setupWalletBalanceNotifications
     */
    func setupWalletBalanceNotifications() {
        // TODO: Setup Wallet Balance Notifications
    }
    
}

