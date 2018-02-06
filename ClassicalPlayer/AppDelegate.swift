//
//  AppDelegate.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let appCoordinator = AppCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = self.window else { return false }
        
        appCoordinator.start(inWindow: window)
        return true
    }
}
