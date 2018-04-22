//
//  UIViewControllerExtension.swift
//  Journal
//
//  Created by Marcus Ng on 1/2/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
//import StoreKit

extension UIViewController {
    
    // Hide keyboard on tap
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Convert hex string to UIColor
    func colorWithHexString (hex: String) -> UIColor {
        let cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = (((cString as NSString).substring(from: 2)) as NSString).substring(to: 2)
        let bString = (((cString as NSString).substring(from: 4)) as NSString).substring(to: 2)
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
//    // Store Kit Review Request
//    func requestReview() {
//        let defaults = UserDefaults.standard
//        if defaults.value(forKey: "Launches") != nil {
//            if defaults.value(forKey: "Launches") as! Int >= 10 {
//                defaults.set(0, forKey: "Launches")
//                SKStoreReviewController.requestReview()
//            }
//        }
//    }
    
}
