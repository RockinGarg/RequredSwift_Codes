//
//  GoogleUser.swift
//  Service App
//
//  Created by IosDeveloper on 26/04/18.
//  Copyright © 2018 ServiceApp. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

//MARK:- FaceBook user
/**
 This class is used to Handle all response from Google/Gmail login
 */
class GoogleUser : NSObject,GIDSignInDelegate,GIDSignInUIDelegate
{
   
    /// Login Delegate object
    var delegate : socialLogin?
    
    //MARK: Configure Gmail User Delegates
    /**
     Function Configures Google Login With ID and Delegate
     - returns: Configuration For Gmail
     */
    func configureGmailLogin() {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "16165068120-8cbil28744e75vcrhpq4sc9gkdglnc2o.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: Sign in delegate
    /**
     Delegate called when required to Sign in a user using gmail Logging
     - parameter signIn : Google Sign In Reference
     - parameter user : Google User which have all the required Details for logging user in App
     - parameter signIn : Error if while logging occurs
     */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            delegate?.loginOutput(.Google, false, error)
        }
        else {
            print("googleUser ID:\(user.userID)")
            print("googleUser Profile Email:\(user.profile.email)")
            print("googleUser Profile Name:\(user.profile.name)")
            
            /// Fetch Data
            LoggedUser.name = user.profile.name
            LoggedUser.email = user.profile.email
            LoggedUser.id = user.userID
            
            /// Save Data in User defaults
            Functions.saveDetailinUserDefaults(value: [LoggedUser.name!,LoggedUser.email!,LoggedUser.id!], key: ["LoggedUser.name","LoggedUser.email","LoggedUser.id"])
            delegate?.loginOutput(.Google, true, nil)
        }
    }
    
    //MARK: Delegate Required Method //Crash Cause
    /**
     Function called Presenting Screen for Login
     - parameter signIn : Google Sign In Reference
     - parameter viewController : viewController to be presented
     */
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) { }
    
    //MARK: Delegate Required Method //Crash Cause
    /**
     Function called Dismissing screen of Login
     - parameter signIn : Google Sign In Reference
     - parameter viewController : viewController to be presented
     */
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) { }
    
    //MARK: Initialisation
    /**
     This is called when need to initiate class
     */
    override init() { }
    
    //MARK: Dienit class
    /**
     This function is used to De-Allocate the class objects
     */
    deinit {
    }
}
