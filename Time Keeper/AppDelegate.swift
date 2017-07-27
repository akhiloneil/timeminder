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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted,error:Error?) in
            // Enable or disable features based on authorization
            if !granted {
                print("App is useless because you didn't allow notifications. Please go to settings and allow all notifications")
            }
        }*/
        //let notificationSettings = UNNotificationSettings(forTypes: [.badge, .alert, .sound], categories:nil)
        //application.registerUserNotificationSettings(notificationSettings)
        
                application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
        
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
        print(userSettings.counter)
        print(userSettings.repeatCount) // For Debugging. Global var for the repeat count on the timer in the pacer view controller
        let x = UIBackgroundTaskIdentifier()
        //if (userSettings.counter < userSettings.repeatCount) {
            //print("made it here into background mode")
            var timer = Timer()
            if !timer.isValid && (userSettings.counter < userSettings.repeatCount) {
                    timer = Timer.scheduledTimer(withTimeInterval: 100, repeats: false, block: { (timer) in
                        application.endBackgroundTask(x)
                        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
                
                
                
                    })
        }

        
        else {
            application.endBackgroundTask(x)
            print("ended background task because the timer was up")
        }
        
        
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

