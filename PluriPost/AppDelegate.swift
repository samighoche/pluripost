//
//  AppDelegate.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/5/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var user1 : user = user()
        user1.name = "Andrew Malek"
        user1.network = "Harvard"
        user1.userImageName = "andrew"
        
        var user2 : user = user()
        user2.name = "Dayne Davis"
        user2.network = "Harvard"
        user2.userImageName = "dayne"
        
        var user3 : user = user()
        user3.name = "Krzysztof Gajos"
        user3.network = "Harvard"
        user3.userImageName = "gajos"
        
        var user4 : user = user()
        user4.name = "Marc Abousleiman"
        user4.network = "Harvard"
        user4.userImageName = "marc"
        
        var user5 : user = user()
        user5.name = "Rish Mukherji"
        user5.network = "Harvard"
        user5.userImageName = "rish"
        
        var user6 : user = user()
        user6.name = "Ryley Reynolds"
        user6.network = "Harvard"
        user6.userImageName = "ryley"
        
        var user7 : user = user()
        user7.name = "Sabrina Mohamed"
        user7.network = "Harvard"
        user7.userImageName = "sabrina"
        
        var user8 : user = user()
        user8.name = "Sami Ghoche"
        user8.network = "Harvard"
        user8.userImageName = "sami"
    
        var user9 : user = user()
        user9.name = "Winston Boucher"
        user9.network = "Harvard"
        user9.userImageName = "winston"

        var users: NSMutableArray = [NSKeyedArchiver.archivedDataWithRootObject(user1),NSKeyedArchiver.archivedDataWithRootObject(user2),NSKeyedArchiver.archivedDataWithRootObject(user3),NSKeyedArchiver.archivedDataWithRootObject(user4),NSKeyedArchiver.archivedDataWithRootObject(user5),NSKeyedArchiver.archivedDataWithRootObject(user6),NSKeyedArchiver.archivedDataWithRootObject(user7),NSKeyedArchiver.archivedDataWithRootObject(user8),NSKeyedArchiver.archivedDataWithRootObject(user9)]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(users, forKey: "users")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

