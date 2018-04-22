//
//  ChangePasscodeVC.swift
//  Scribio
//
//  Created by Marcus Ng on 1/5/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
import SmileLock
import KeychainSwift

class ChangePasscodeVC: UIViewController {

    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordLbl: UILabel!
    
    var firstPasscode: String = ""
    var confirmPasscode: Bool = false
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 20) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        passwordLbl.text = "Enter New Passcode"
        
        // Create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.deleteButtonLocalizedTitle = "Delete"
        
        // Disable Touch ID
        passwordContainerView.touchAuthenticationEnabled = false
        
        // Customize password UI
        passwordContainerView.tintColor = colorWithHexString(hex: "707070")
        passwordContainerView.highlightedColor = colorWithHexString(hex: "2C91FF")
    }
    
    func passcodeSetup(input: String, text: String, confirm: Bool) {
        firstPasscode = input
        passwordLbl.text = text
        confirmPasscode = confirm
    }

    func saveNewPasscode(input: String) {
        let keychain = KeychainSwift()
        keychain.set(input, forKey: "passcode")
    }
}

extension ChangePasscodeVC: PasswordInputCompleteProtocol {
    
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        // First Passcode
        if !confirmPasscode {
            passcodeSetup(input: input, text: "Confirm Passcode", confirm: true)
            passwordContainerView.clearInput()
        } else { // Confirm Passcode
            if validation(input) {
                // Success
                saveNewPasscode(input: input)
                UserDefaults.standard.set(true, forKey: "PasscodeEnabled")
                performSegue(withIdentifier: "unwindToPasscodeTVC", sender: nil)
            } else {
                // Failure
                passwordContainerView.wrongPassword()
                passcodeSetup(input: "", text: "Enter New Passcode", confirm: false)
            }
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        return
    }
    
}

extension ChangePasscodeVC {
    
    func validation(_ input: String) -> Bool {
        return firstPasscode == input
    }
    
    func validationSuccess() {
        print("Success!")
    }
    
    func validationFail() {
        print("Failure!")
        passwordContainerView.wrongPassword()
    }
    
}
