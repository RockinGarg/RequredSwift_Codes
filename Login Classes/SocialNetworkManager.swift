//
//  SocialNetworkManager.swift
//  Service App
//
//  Created by IosDeveloper on 26/04/18.
//  Copyright © 2018 ServiceApp. All rights reserved.
//

import UIKit

//MARK: Enum for User login procedure
/**
 This Enum is used to check user is Logging Using which type of network ?
 */
enum loginType {
    /// When User login with Facebook
    case Facebook
    /// When User login with Google
    case Google
    /// When User login with Email
    case Email
}

//MARK: Login Delegate - Output from class
/**
 This protocol is used to get the output from Social Login Classes
 */
protocol socialLogin : class {
    //MARK: Login Output
    /**
     This protocol is used to get the output from Social Login Classes
     - parameter loginType : Return Type is Facebook,Google or Email
     - parameter success : Returns true if Login is Successful
     - parameter error : returns Error is there is any Error while logging in
     */
    func loginOutput(_ loginType: loginType,_ success: Bool,_ error:Error?)
    
    //MARK: is Login Cancelled ?
    /**
     This protocol is used to check is login was cancelled
     - parameter loginType : Return Type is Facebook,Google or Email
     - parameter isCancelled : Returns true if Login is canceled
     */
    func loginCancelled(_ loginType: loginType,_ isCancelled: Bool)
}

//MARK:- Protocol for Social Networks
/**
 This protocol is used to hanlde response from all the social network
 */
protocol socialNetworkDelegate : class {
    //MARK: Login Status
    /**
     This function is used to check is Login using network was Successful ?
     - parameter success : did Login was Successful ?
     - parameter loginType : Login was done using of network type ?
     */
    func loginStatus(success:Bool,loginType:loginType,error:Error?)
    
    //MARK: Login Cancelled
    /**
     This function is called to notify that user had Cancelled Login Using Social Network
     */
    func loginWasCancelled()
}

//MARK: Social Network Manager
/**
 This class Handle all the Login Procedures as follows
 - Google Login
 - Facebook Login
 - Normal Email Based Login
 
 Usage ->
 /// Social Network Class Object
 private var socialNetworkClassObj : SocialNetworkManager?
 socialNetworkClassObj = SocialNetworkManager()
 socialNetworkClassObj?.delegate = self
 socialNetworkClassObj?.loginWithEmail()
 */
class SocialNetworkManager: NSObject
{
    /// social Manager Delgate object
    var delegate : socialNetworkDelegate?
    /// facebook User class Object
    private var facebookClass : FacebookUser?
    /// Google User Class Object
    private var googleClass : GoogleUser?
    
    //MARK: Initialise Class
    /**
     This function is used to Initialise the class
     */
    override init() {}
    
    //MARK: Dienit class
    /**
     This function is used to De-Allocate the class objects
     */
    deinit {
        facebookClass = nil
        googleClass = nil
    }
    
    //MARK: Google Login
    /**
     This function is used to login user using Google Account
     */
    func loginWithGoogle() {
        googleClass = GoogleUser()
        googleClass?.delegate = self
        googleClass?.configureGmailLogin()
    }

    //MARK: Facebook Login
    /**
     This function is used to login user using Facebook Account
     */
    func loginWithFacebook(_ viewcontroller: UIViewController) {
        facebookClass = FacebookUser()
        facebookClass?.delegate = self
        facebookClass?.configureFacebookLogin(viewcontroller)
    }
    
    //MARK: Normal Login
    /**
     This function is used to login user using server based email Created
     */
    func loginWithEmail() {
        delegate?.loginStatus(success: true, loginType: .Email, error: nil)
    }
}

//MARK: Social Login Protocol
extension SocialNetworkManager : socialLogin {
    //MARK: is Login Cancelled ?
    /**
     This protocol is used to check is login was cancelled
     - parameter loginType : Return Type is Facebook,Google or Email
     - parameter isCancelled : Returns true if Login is canceled
     */
    func loginCancelled(_ loginType: loginType, _ isCancelled: Bool) {
        /// Delegate is used only for Facebook Case , So multiple
        /// checks are not required
        facebookClass?.delegate = nil
        facebookClass = nil
        self.delegate?.loginWasCancelled()
    }
    
    //MARK: Login Output
    /**
     This protocol is used to get the output from Social Login Classes
     - parameter loginType : Return Type is Facebook,Google or Email
     - parameter success : Returns true if Login is Successful
     - parameter error : returns Error is there is any Error while logging in
     */
    func loginOutput(_ loginType: loginType, _ success: Bool, _ error: Error?) {
        switch loginType {
        case .Facebook:
            if error != nil {
                facebookClass?.delegate = nil
                facebookClass = nil
                delegate?.loginStatus(success: success, loginType: .Facebook, error: error)
            }
            else{
                facebookClass?.delegate = nil
                facebookClass = nil
                delegate?.loginStatus(success: success, loginType: .Facebook, error: nil)
            }
            break
        case .Google:
            if error != nil {
                googleClass?.delegate = nil
                googleClass = nil
                delegate?.loginStatus(success: success, loginType: .Google, error: error)
            }
            else{
                googleClass?.delegate = nil
                googleClass = nil
                delegate?.loginStatus(success: success, loginType: .Google, error: nil)
            }
            break
        default:
            delegate?.loginStatus(success: true, loginType: .Email, error: nil)
            break
        }
    }
}
