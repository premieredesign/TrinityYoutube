//
//  AppDelegate.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/22/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /*
     1. First to get rid of the storyboard and use programmatically, take the window var created and set the UIWindow(frame: UIScreen.main.bounds)
     2. Second make it visible: -> window?.makeKeyAndVisible()
     3. Set the rootViewController: -> this can be a navigation controller or View controller etc. "Please see below"
     */

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .horizontal
        
        window?.rootViewController = UINavigationController(rootViewController: CollectionViewController(collectionViewLayout: layout))
//        window?.rootViewController = UINavigationController(rootViewController: TestController(collectionViewLayout: layout))
        
//        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))

        //MARK: - Blue Color for Navigation Bar
        UINavigationBar.appearance().barTintColor = .clear // blue color
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        application.statusBarStyle = .lightContent
        
        
        
        
        let statusBarBackground = UIView()
        statusBarBackground.backgroundColor = .clear
        
        window?.addSubview(statusBarBackground)
        window?.addContraintsWithFormat(format: "H:|[v0]|", views: statusBarBackground)
        window?.addContraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackground)
        
        return true
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

