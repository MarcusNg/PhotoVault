//
//  PasscodeVC.swift
//  Scribio
//
//  Created by Marcus Ng on 1/5/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
import SmileLock
import KeychainSwift

class PasscodeVC: UIViewController {

    @IBOutlet weak var passwordStackView: UIStackView!

    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.deleteButtonLocalizedTitle = "Delete"
        
        // Touch ID
        passwordContainerView.touchAuthenticationEnabled = UserDefaults.standard.value(forKey: "TouchIDEnabled") as! Bool
        
        // Customize password UI
        passwordContainerView.tintColor = colorWithHexString(hex: "707070")
        passwordContainerView.highlightedColor = colorWithHexString(hex: "23A2FD")
        
    }
    
}

extension PasscodeVC: PasswordInputCompleteProtocol {
    
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        if validation(input) {
            // Success
            validationSuccess()
        } else {
            // Failure
            validationFail()
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            // Success
            validationSuccess()
        } else {
            // Failure
            passwordContainerView.clearInput()
        }
    }
    
}

extension PasscodeVC {
    
    func validation(_ input: String) -> Bool {
        let keychain = KeychainSwift()
        let pass = keychain.get("passcode")
        return input == pass
    }
    
    func validationSuccess() {
        print("Success!")
        performSegue(withIdentifier: TO_NAVIGATION, sender: nil)
    }
    
    func validationFail() {
        print("Failure!")
        passwordContainerView.wrongPassword()
    }
    
}
