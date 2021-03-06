//
//  AppDelegate.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 23/11/2016.
//  Copyright © 2016 Alex Johnson. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Override point for customization after application launch.
        Fabric.with([Twitter.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        //window?.rootViewController = TabBarController()
        window?.rootViewController = UINavigationController(rootViewController: ViewController(collectionViewLayout: layout))
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 65/255, blue: 90/255, alpha: 1)
        
        //UINavigationBar.appearance().barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor(red: 0/255, green: 65/255, blue: 90/255, alpha: 1)
        //statusBarBackgroundView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue:255/255, alpha: 1)

        statusBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : statusBarBackgroundView]))
        window?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : statusBarBackgroundView]))
        
        
        application.statusBarStyle = .lightContent
        //application.statusBarStyle = .default
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        if Twitter.sharedInstance().application(app, open:url, options: options) {
            return true
        }
        
        return handled
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

