//
//  AppDelegate.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .orange

        let navController = UINavigationController(rootViewController: rootVC)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

