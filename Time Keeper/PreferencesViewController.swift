//
//  PreferencesViewController.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/4/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit





class PreferencesViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
    }
    //var appMode: Bool = true
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
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
