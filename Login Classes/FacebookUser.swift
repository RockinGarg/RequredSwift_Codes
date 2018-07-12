//
//  FacebookUser.swift
//  Service App
//
//  Created by IosDeveloper on 26/04/18.
//  Copyright © 2018 ServiceApp. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

//MARK:- FaceBook user
/**
 This class is used to Handle all response from facebook login
 */
class FacebookUser : NSObject,FBSDKLoginButtonDelegate {
    /// Login Delegate object
    var delegate : socialLogin?
    /// FBSDKLoginManager class object
    private var fbLoginManager : FBSDKLoginManager?
    
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
        fbLoginManager = nil
    }
    
    //MARK: Configure Facebook
    /**
     This function is called when required to login Facebook
     - parameter viewcontroller : Controller in which Facebook login is initiated
     */
    func configureFacebookLogin(_ viewcontroller: UIViewController) {
        /// Set Current Profile as Nil
        FBSDKProfile.setCurrent(nil)
        fbLoginManager = FBSDKLoginManager()
        fbLoginManager?.logOut()
        fbLoginManager?.logIn(withReadPermissions: ["email"], from: viewcontroller) { (result, error) in
            if (error == nil)
            {
                if (result?.isCancelled)!{
                    self.delegate?.loginCancelled(.Facebook, true)
                    return
                }
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData(success: { (facebookData) in
                            print("Facebook Login Response:\(facebookData)")
                            LoggedUser.name = facebookData["name"] as? String
                            LoggedUser.email = facebookData["email"] as? String
                            if let value = facebookData["id"]{
                                if value is NSNumber {
                                    LoggedUser.id = "\(value)"
                                }
                                else{
                                    LoggedUser.id = value as? String
                                }
                            }
                            if LoggedUser.email == nil {
                                /// Save Data in User defaults
                                Functions.saveDetailinUserDefaults(value: [LoggedUser.name!,LoggedUser.id!], key: ["LoggedUser.name","LoggedUser.id"])
                            }
                            else{
                                /// Save Data in User defaults
                                Functions.saveDetailinUserDefaults(value: [LoggedUser.name!,LoggedUser.email!,LoggedUser.id!], key: ["LoggedUser.name","LoggedUser.email","LoggedUser.id"])
                            }
                            
                            self.delegate?.loginOutput(.Facebook, true, nil)
                        }, failure: { (error) in
                            self.delegate?.loginOutput(.Facebook, false, error)
                        })
                    }
                }
            }
            else{
                self.delegate?.loginOutput(.Facebook, false, error)
            }
        }
    }
    
    //MARK: Facebook Graph API
    /**
     This function handle the response from Facebook Graph API
     - parameter success : Returns [String:AnyObject] if login is Successfull
     - parameter failure : Returns Error if login is failed
     */
    func getFBUserData(success:@escaping ([String:AnyObject]) -> Void, failure:@escaping (Error) -> Void) {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    /// Dismiss Indicator Running
                    return success((result as? [String:AnyObject])!)
                }
                else {
                    /// Error case
                    failure(error!)
                }
            })
        }
    }
    
    //MARK: Default delegate Method for Login
    /**
     Button Delegate for Facebook
     - parameter loginButton: FBLogin Button Instance
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) { }
    
    //MARK: Default delegate Method for Logout
    /**
     Button Delegate for Facebook when Logout
     - parameter loginButton: FBLogin Button Instance
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { }
}
