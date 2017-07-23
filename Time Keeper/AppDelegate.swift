//
//  AppDelegate.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/3/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation

var launch: Bool = false 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
                        return true
    } 

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UNMutableNotificationContent().badge = 0
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //print(userSettings.counter)
        //print(userSettings.repeatCount) // For Debugging. Global var for the repeat count on the timer in the pacer view controller
        
        //print(CACurrentMediaTime())
        /*let x = UIBackgroundTaskIdentifier()
        //if (userSettings.counter < userSettings.repeatCount) {
            //print("made it here into background mode")
            var timer = Timer()
            if !timer.isValid {
                    timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                        application.endBackgroundTask(x)
                        application.beginBackgroundTask(withName: "showAlert", expirationHandler: nil)
                        print("made it in the background renewal")
                
                
                    })
        }*/
        
        
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //UNMutableNotificationContent().badge = 0
    }


}

