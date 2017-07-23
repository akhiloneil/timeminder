//
//  PacerViewController.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/20/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox
import AVFoundation
import CoreMotion

struct userSettings {
    static var modeSettings = true
    static var repeatCount = 0
    static var counter = 0
}

class PacerViewController: UIViewController, UNUserNotificationCenterDelegate, UITextFieldDelegate {
    var isGrantedAccess = false
    var timeInterval: Double = 0.0
    var totalTime: Double = 0.0
    var keepRepeating: Bool = true
    var appProblem: Bool = false
    //var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    //var counter: Int = 0
    //var debugX = 0
    //var modeSetting: Bool = false
    let soundFileNames = ["CidadeConvertAudio"]
    var audioPlayers = [AVAudioPlayer]()
    var motionManager = CMMotionManager()
    
    @IBOutlet var timeHoursInput: UITextField!
    @IBOutlet var timeMinutesInput: UITextField!
    @IBOutlet var timeSecondsInput: UITextField!
    @IBOutlet var intervalHoursInput: UITextField!
    @IBOutlet var intervalMinutesInput: UITextField!
    @IBOutlet var intervalSecondsInput: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var timer = Timer()
    
    /*override func viewDidAppear(_ animated: Bool) {
        
        motionManager.gyroUpdateInterval = 0.5
        
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                if myData.rotationRate.x > 3
                {
                    print("You tilted your device")
                }
            }
        }
    }*/

    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
        if launch && self.isGrantedAccess {
            self.sendAlert(title: "Welcome to TimeMinder", message: "To use the app, specifiy how long you want the alerts to continue for and how often you would like them. As of V1.1, the app doesn't work in the background.")
            launch = false
            }})

    }
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        startTimer()
        activityIndicator.startAnimating()
        statusLabel.text = "Starting \(userSettings.counter + 1) of \(userSettings.repeatCount)"
        
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
        activityIndicator.stopAnimating()
        statusLabel.text = "Status: Not running"
    }
    
    @IBAction func resetButton (_ sender: UIButton)
    {
        resetValues()
    }
    
    /*let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .none
        nf.minimumIntegerDigits = 0
        nf.maximumIntegerDigits = 1
        return nf
    }()*/
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (ACTION) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore
        {
            launch = false
        }
        else {
            launch = true
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }

                UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(granted, error) in
                self.isGrantedAccess = granted
        }
        // Add "STOP" button for the notification
        //let stopAction = UNNotificationAction(identifier: "stop.action", title: "Stop", options: [])
        
        //let timerCategory = UNNotificationCategory(identifier: "timer.category", actions: [stopAction], intentIdentifiers: [], options: [])
        //UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        
        intervalHoursInput.delegate = self
        intervalMinutesInput.delegate = self
        intervalSecondsInput.delegate = self
        
        //UNMutableNotificationContent().badge = 0
        
        //self.intervalHoursInput.mask = "#"
        
        for sound in soundFileNames {
            do {
                // Try to do something
                let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "wav")!)
                let audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
                
                audioPlayers.append(audioPlayer)
            }
        
        catch {
            // Catch error thrown
            audioPlayers.append(AVAudioPlayer())
        }
            
    }
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        
        catch {
            
        }
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
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.timeHoursInput) {
            let maskTextField = textField as! text
            return maskTextField.shouldChangeCharacters(in: range, replacementString: string)
        }; return true
    
    }*/
    func sendNotifcation() {
        if isGrantedAccess {
            let content = UNMutableNotificationContent()
            content.badge = 0
            content.title = "TimeMinder Interval Alert"
            //content.body = "\(timeInterval) \(keepRepeating) \(userSettings.counter) \(String(describing: content.badge))"
            content.body = "Reminder \(userSettings.counter + 1) of \(userSettings.repeatCount)"
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
               print("vibrate")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        // Send request and then send notification
            let request = UNNotificationRequest(identifier: "timer.request", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("error posting notification: \(error.localizedDescription)")
                }
            }
            
            /*let userMode = userSettings.modeSettings
            if userMode == true {     // This mode is for sound Alerts. Currently the sound isn't customizable
                //content.sound = UNNotificationSound(named: "CidadeConvertAudio.wav")
                audioPlayers[0].play()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            else {
                // Vibrate for Alerts if User Selected Discrete/Silent Mode
                print("vibrate")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }*/
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
        

//        if ((validHoursIntervalInput != true) && (validMinutesIntervalInput != true) && (validSecondsIntervalInput != true)) {
//            timeInterval = 10.0 // default time interval
//            
//        }
        

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
        
//        if ((validHoursTimeInput != true) && (validMinutesTimeInput != true) && (validSecondsTimeInput != true)) {
//            totalTime = 7200   // Default max time is 2 hours
//        }
        
        // See if the timer alerts should continue repeating or if the notifications are done.
        // If notifications are done, then the code that executes is similar to that in stopTimer func
        
        if (validHoursTimeInput != true) && (validMinutesTimeInput != true) && (validSecondsTimeInput != true) && (validHoursIntervalInput != true) && (validMinutesIntervalInput != true) && (validSecondsIntervalInput != true)
            //Check for no input at all
        {
            sendAlert(title: "No Time Interval Selected", message: "Please select a time interval")
            appProblem = true
            resetValues()
        }
        
        else if (validHoursIntervalInput != true) && (validMinutesIntervalInput != true) && (validSecondsIntervalInput != true) {   // Check for no interval input
            sendAlert(title: "Error: No Time Interval Selected", message: "Please select a time interval")
            appProblem = true
            resetValues()
        }
        
        else if (validHoursTimeInput != true) && (validMinutesTimeInput != true) && (validSecondsTimeInput != true) && timeInterval >= 5
        // check for valid interval input but no time input
        {
            totalTime = 7200
            sendAlert(title: "Warning", message: "Total time was not selected; defaulting to 2 hours")
            appProblem = false
        }
        
            
        else if (totalTime < timeInterval) {
            sendAlert(title: "Error: Total Time is less than Time Interval", message: "Please enter a valid time interval")
            appProblem = true
            resetValues()
        }
        
        if /*(validHoursTimeInput != true) && (validMinutesTimeInput != true) && (validSecondsTimeInput != true) && */ timeInterval < 5 {
            sendAlert(title: "Error: Time Interval is too short", message: "Please enter a time interval of 5 seconds or more")
            appProblem = true
            resetValues()
        }

        if totalTime > 14400 {
            print("total time too long")
            sendAlert(title: "Error: Max time is 4 Hours", message: "Please choose a total time of 4 hours or less")
            appProblem = true
            resetValues()
            
        }

        
        
        
        if appProblem != true && totalTime != timeInterval {
        userSettings.repeatCount = Int(floor(totalTime/timeInterval))
        print("Skipping if statement")
        }
        else if totalTime == timeInterval {
            userSettings.repeatCount = 1
            print("equals 1")
            appProblem = false
        }
        
       
        
        //if (counter >= debugX) {
        //    keepRepeating = false
         //   print("Setting counter to false")
        //}
        
        
        
        // The piece of code that starts the timer...
        if isGrantedAccess && !timer.isValid && appProblem != true{
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: self.keepRepeating, block: { (timer) in
                self.sendNotifcation()
                self.statusLabel.text = "Starting \(userSettings.counter + 2) of \(userSettings.repeatCount)"
                //print("vibrate")
                //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                //self.sendNotifcation()
                userSettings.counter += 1         // Increment the LOOP Counter every time a notification is sent
                print("\(userSettings.repeatCount)  \(userSettings.counter)")
                //self.vibratePhone(vibrationCount: 1)
                if userSettings.counter >= userSettings.repeatCount {
                    timer.invalidate()
                    self.sendAlert(title: "TimeMinders are finished", message: "Task completed")
                    //UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    self.resetValues()
                    self.keepRepeating = false
                    print("Shutting timer off")
                }
            })
        }
        else {
//           if timeInterval < 5 {
//                print("time interval too short.")
//                sendAlert(title: "Error: Time interval too short", message: "Please choose an interval time of at least 5 seconds")
//                resetValues()
//            }
            if isGrantedAccess == false {
                    print("must enable notifications for app to work")
                    sendAlert(title: "Error: Notifications must be enabled", message: "Please go to Settings and enable notifications")
                    resetValues()
                
            }
        }
        
    }
    
    func stopTimer() {
        // shut down timer
        timer.invalidate()
        print("stopping all alerts")
        // clear out any pending and delivered notifications
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
        userSettings.counter = 0       // Globabl var counter found in struct userSettings
        activityIndicator.stopAnimating()
        statusLabel.text = "Status: Not running"
        
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
