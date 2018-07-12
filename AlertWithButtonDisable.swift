//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

let alertController = UIAlertController(title: "Service App", message: "Please Enter your Email", preferredStyle: .alert)
alertController.addTextField { (textField : UITextField!) -> Void in
    textField.placeholder = "E-mail"
    textField.addTarget(self, action: #selector(login_SignUp_VC.textChanged(_:)), for: .editingChanged)
}

let okAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
    let firstTextField = alertController.textFields![0] as UITextField
    print("Email \(firstTextField.text ?? "")")
    /// Save Data
    /// Navigate
})

let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (handler) in
    print("Login is cancelled")
}

alertController.addAction(okAction)
alertController.addAction(cancelAction)
alertController.actions[0].isEnabled = false
self.present(alertController, animated: true, completion: nil)

//MARK: Apple ID alert Handler
/**
 This function is used to Validate a condition in Alert to enable or disable a Button
 - parameter sender: TextFeild Delegate handler
 - returns: Validation
 */
@objc private func textChanged(_ sender: Any)
{
    let tf = sender as! UITextField
    var resp : UIResponder! = tf
    while !(resp is UIAlertController) { resp = resp.next }
    let alert = resp as! UIAlertController
    alert.actions[0].isEnabled = Functions.isValidEmail(tf.text!)
}

//MARK: Valid Email
/**
 This Function will check is Valid Email Entered By user
 - parameter TF : TextField Whose Text is to be checked
 - returns Bool : True if email is Valid else False
 */
class func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
