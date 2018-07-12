//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- String Extensions
extension String
{
    //MARK: BasicAlert
    /**
     This function is used to split a String in equal Length
     - parameter length: Length By which String is to be Divided
     - returns: Array of Splitted String
     */
    func splitByLength(_ length: Int) -> [String] {
        var result = [String]()
        var collectedCharacters = [Character]()
        collectedCharacters.reserveCapacity(length)
        var count = 0
        
        for character in self {
            collectedCharacters.append(character)
            count += 1
            if (count == length) {
                // Reached the desired length
                count = 0
                result.append(String(collectedCharacters))
                collectedCharacters.removeAll(keepingCapacity: true)
            }
        }
        
        // Append the remainder
        if !collectedCharacters.isEmpty {
            result.append(String(collectedCharacters))
        }
        
        return result
    }
}

//MARK:- Method to check if device is iPad or iPhone
/**
 This Class is used to check current device iPad or iPhone
 * Use : self.font = ExamplesDefaults.fontWithSize(Env.iPad ? 20 : 14)
 
 - returns: Bool Yes if iPad
 */
class Env
{
    /// Static App URL
    static var baseURL = "http://54.183.245.32/"
    
    /// Check if its iPad
    static var iPad: Bool
    {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Check is Device is iPhone X
    static var iPhoneX : Bool
    {
        /// Bool Value for status of iPhone X
        var isIphoneX : Bool!
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                isIphoneX = true
            }
            else{
                isIphoneX = false
            }
        }
        return isIphoneX
    }
}

//MARK:- UIViewController Extensions
extension UIViewController
{
    //MARK: BasicAlert
    /**
     This function is used to Show a basic alert message
     - parameter title: Main Title
     - parameter message: Main Message
     - parameter view: View Controller object
     - returns: Alert
     */
    func BasicAlert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Show ConfirmatonView
    /**
     This function is used show the confirmationView Xib with text Passing
     */
    func showConfirmationView(staticText:String) -> ConfirmationView
    {
        let newView = ConfirmationView.init(frame: self.view.bounds)
        newView.headerLabel.text = staticText
        return newView
    }
    
    //MARK: Add a toast message on Screen
    /**
     This function is used to show a toast on screen
     - parameter message : String Value that is to added on Toast View
     */
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations:
            {
                toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK:- UIView Extensions
extension UIView
{
    //MARK: Round Corners
    /**
     This Function Round Only corners of the View
     */
    func roundCornersOfView() {
        self.layer.cornerRadius = Env.iPad ? 30.0 : Env.iPhoneX ? 5 : 5
        self.layer.masksToBounds = true
    }
    
    //MARK: Circle View
    /**
     This Function is used to make a View Circle Shape
     */
    func makeViewCircle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
    
    
    //MARK: Add Border To a UIView
    /**
     This Function is used to add Border With a Color to UIView
     */
    func addBorderToView(color:UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    //MARK: Add Shadow To UIView
    /**
     This Function is used to add shadow to UIView
     - parameter color : color of shadow
     */
    func addShadowToView(color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
    }
    
    //MARK: Round corner + Border + Shadow
    /**
     This Function is used add Border and Shadow Effect
     - parameter color : Border color
     */
    func roundCornerWithBorderAndShadow(borderColor:UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = Env.iPad ? 30.0 : Env.iPhoneX ? 5 : 5
    }
    
    //MARK: Round corner + Border + Shadow
    /**
     This Function is used add Rounded Corner and Shadow Effect
     - parameter color : Shadow color
     */
    func addshadowWithRoundedCorner(color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = Env.iPad ? 30.0 : Env.iPhoneX ? 5 : 5
    }
    
    //MARK: Add Shadow in Slected Sides
    /**
     This Function is used add shadow in swlected proportions of UIView
     - parameter color : Shadow color
     - parameter corners : corners where shadow is to be added
     */
    func addShadowToViewWithEnum(color:UIColor,corners:shadowCorners) {
        switch corners {
        case .allFour:
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        case .bottom_left_right:
            self.layer.shadowOffset = CGSize(width: 0, height: 6)
        case .top_left_right:
            self.layer.shadowOffset = CGSize(width: 0, height: -6)
        default:
            let shadowRect = self.bounds.insetBy(dx: 0, dy: 4)
            self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowRadius = 5
    }
}

//MARK:- UIImageView Extensions
extension UIImageView
{
    //MARK: Add Shadow in Slected Sides
    /**
     This Function is used to round the corners of UIImageView
     */
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
