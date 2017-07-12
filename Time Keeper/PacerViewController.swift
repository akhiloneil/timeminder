//
//  PacerViewController.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/3/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

struct userSettings {
    static var modeSettings = true
    static var completeTime: Double = 0.0
}

class PacerViewController: UIViewController, UNUserNotificationCenterDelegate, UITextFieldDelegate{
    var isGrantedAccess = false
    var timeInterval: Double = 0.0
    
    var keepRepeating: Bool = true
    var counter: Int = 0
    var debugX = 0
    //var modeSetting: Bool = false
    
    var totalTime: Double = userSettings.completeTime
    
    @IBOutlet var timeHoursInput: UITextField!
    @IBOutlet var timeMinutesInput: UITextField!
    @IBOutlet var timeSecondsInput: UITextField!
    @IBOutlet var intervalHoursInput: UITextField!
    @IBOutlet var intervalMinutesInput: UITextField!
    @IBOutlet var intervalSecondsInput: UITextField!
    
    private var timer = Timer()

    @IBAction func buttonPressed(_ sender: UIButton)
    {
        startTimer()
    
        /*let content = UNMutableNotificationContent()
        content.title = "The 5 seconds are up"
        content.subtitle = "They are up now"
        content.body = " The 5 seconds are really up!"
        content.badge = 1
    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 100, repeats: true)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)*/
    }
    
    @IBAction func stopButton(_ sender: UIButton)
    {
        stopTimer()
    }
    
    @IBAction func resetButton (_ sender: UIButton)
    {
        resetValues()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(granted, error) in
                self.isGrantedAccess = granted
        }
        // Add "STOP" button for the notification
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "Stop", options: [])
        
        let timerCategory = UNNotificationCategory(identifier: "timer.category", actions: [stopAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        
        intervalHoursInput.delegate = self
        intervalMinutesInput.delegate = self
        intervalSecondsInput.delegate = self
        
        UNMutableNotificationContent().badge = 0
        
        
        
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        if response.actionIdentifier == "stop.action" {
            stopTimer()
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func sendNotifcation() {
        if isGrantedAccess {
            let content = UNMutableNotificationContent()
            content.badge = 0
            content.title = "Sound Interval Alert"
            content.body = "\(timeInterval) \(keepRepeating) \(counter) \(String(describing: content.badge))"
            //content.sound = UNNotificationSound(named: "CidadeConvertAudio.wav")
            content.categoryIdentifier = "timer.category"
            
            
            // immediate notification
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
            // Access the user settings
            let userMode = userSettings.modeSettings
            if userMode == true {     // This mode is for sound Alerts. Currently the sound isn't customizable
                content.sound = UNNotificationSound(named: "CidadeConvertAudio.wav")
            }
            else {
                // Vibrate for Alerts if User Selected Discrete/Silent Mode
               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        // Send request and then send notification
            let request = UNNotificationRequest(identifier: "timer.request", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("error posting notification: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    // Start sending the notifications/alerts *** IMPORTANCE: HIGH
    func startTimer() {
        // Used for verifying valid user input for interval time
        //print("\(modeSetting)")
        keepRepeating = true
        var validHoursIntervalInput: Bool
        var validMinutesIntervalInput: Bool
        var validSecondsIntervalInput: Bool
        
        // Used for verifying valid user input for total time
        var validHoursTimeInput: Bool
        var validMinutesTimeInput: Bool
        var validSecondsTimeInput: Bool
        
        
        if let hoursIntervalInput = Double(intervalHoursInput.text!) {
            timeInterval = hoursIntervalInput * 3600
            validHoursIntervalInput = true
        } else {
            validHoursIntervalInput = false
        }
        
        if let minutesIntervalInput = Double(intervalMinutesInput.text!) {
            timeInterval += (minutesIntervalInput * 60)
            validMinutesIntervalInput = true
        }
        else {
            validMinutesIntervalInput = false
        }
        
        if let secondsIntervalInput = Double(intervalSecondsInput.text!) {
            timeInterval += secondsIntervalInput
            validSecondsIntervalInput = true
        } else {
            validSecondsIntervalInput = false
        }
        
        if ((validHoursIntervalInput != true) && (validMinutesIntervalInput != true) && (validSecondsIntervalInput != true)) {
            timeInterval = 10.0 // default time interval
        }
        // Send notifications/alerts if everything is valid and usable (Different settings for different modes)
        /*if isGrantedAccess && !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
                self.sendNotifcation()
            })
        }*/
        
        if let hoursTimeInput = Double(timeHoursInput.text!) {
            totalTime = hoursTimeInput * 3600
            validHoursTimeInput = true
        }
        else {
            validHoursTimeInput = false
        }
        
        if let minutesTimeInput = Double(timeMinutesInput.text!) {
            totalTime += minutesTimeInput * 60
            validMinutesTimeInput = true
        }
        else {
            validMinutesTimeInput = false
        }

        if let secondsTimeInput = Double(timeSecondsInput.text!) {
            totalTime += secondsTimeInput
            validSecondsTimeInput = true
        }
        else {
            validSecondsTimeInput = false
        }
        
        if ((validHoursTimeInput != true) && (validMinutesTimeInput != true) && (validSecondsTimeInput != true)) {
            totalTime = 7200   // Default max time is 2 hours
        }
        
        // See if the timer alerts should continue repeating or if the notifications are done.
        // If notifications are done, then the code that executes is similar to that in stopTimer func
        debugX = Int(floor(totalTime/timeInterval))
        print("Skipping if statement")
        //if (counter >= debugX) {
        //    keepRepeating = false
         //   print("Setting counter to false")
        //}
        
        
        
        // The piece of code that starts the timer...
        if isGrantedAccess && !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: self.keepRepeating, block: { (timer) in
                self.sendNotifcation()
                self.sendNotifcation()
                self.counter += 1         // Increment the LOOP Counter every time a notification is sent
                print("\(self.debugX)  \(self.counter)")
                //self.vibratePhone(vibrationCount: 1)
                if self.counter >= self.debugX {
                    timer.invalidate()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    self.resetValues()
                    self.keepRepeating = false
                    print("Shutting timer off")
                }
            })
        }
    }
    
    func stopTimer() {
        // shut down timer
        timer.invalidate()
        print("stopping all alerts")
        // clear out any pending and delivered notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        // reset total time and interval time
        resetValues()
    }
    
    func resetValues() {
        // reset all values
        timeInterval = 0.0
        totalTime = 0.0
        timeHoursInput.text = ""
        timeMinutesInput.text = ""
        timeSecondsInput.text = ""
        intervalHoursInput.text = ""
        intervalMinutesInput.text = ""
        intervalSecondsInput.text = ""
        counter = 0
        
        
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        timeHoursInput.resignFirstResponder()
        timeMinutesInput.resignFirstResponder()
        timeSecondsInput.resignFirstResponder()
        intervalHoursInput.resignFirstResponder()
        intervalMinutesInput.resignFirstResponder()
        intervalSecondsInput.resignFirstResponder()
        
       
    }
    
    
}
