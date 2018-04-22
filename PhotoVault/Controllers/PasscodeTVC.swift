//
//  PasscodeTVC.swift
//  Scribio
//
//  Created by Marcus Ng on 1/5/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
import KeychainSwift

class PasscodeTVC: UITableViewController {

    @IBOutlet weak var enablePasscodeSwitch: UISwitch!
    @IBOutlet weak var enableTouchIDSwitch: UISwitch!
    
    @IBAction func prepareForUnwindToPasscodeTVC(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 20) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        update()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        update()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if enablePasscodeSwitch.isOn {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2 // Passcode, Change Passcode
        }
        return 1 // Touch ID
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Passcode
            if indexPath.row == 1 { // Change passcode
                performSegue(withIdentifier: TO_CHANGE_PASSCODE, sender: nil)
            }
        }
    }

    @IBAction func enablePasscodeSwitchPressed(_ sender: Any) {
        
        if enablePasscodeSwitch.isOn {
            // Delete passcode from keychain, segue to change passcode
            performSegue(withIdentifier: TO_CHANGE_PASSCODE, sender: nil)
            tableView.reloadData()
        } else {
            UserDefaults.standard.set(false, forKey: "PasscodeEnabled")
            tableView.reloadData()
        }
    }
    
    @IBAction func enabledTouchIDSwitchPressed(_ sender: Any) {
        if enableTouchIDSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "TouchIDEnabled")
            tableView.reloadData()
        } else {
            UserDefaults.standard.set(false, forKey: "TouchIDEnabled")
            tableView.reloadData()
        }
    }
    
    func update() {
        enablePasscodeSwitch.isOn = UserDefaults.standard.value(forKey: "PasscodeEnabled") as! Bool
        enableTouchIDSwitch.isOn = UserDefaults.standard.value(forKey: "TouchIDEnabled") as! Bool
        tableView.reloadData()
    }
    
}
