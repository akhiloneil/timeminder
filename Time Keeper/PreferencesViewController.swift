//
//  PreferencesViewController.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/4/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit

protocol PreferencesDelegate {
    func passUserSettings(settings: Bool)
}



class PreferencesViewController: UITableViewController {
    
    
    
    //var appMode: Bool = true
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("Sound Alerts {ON}")
            userSettings.modeSettings = true
        case 1:
            print("Vibration ONLY mode {ON}")
            userSettings.modeSettings = false
        default:
            break
        }
    }
    
    
}
