//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

/// account_Settings VC class Object
private lazy var myAppointmentsVCObject: myAppointmentsVC =
{
    // Instantiate View Controller
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "myAppointmentsVC") as! myAppointmentsVC
    // Add View Controller as Child View Controller
    self.addChildViewController(viewController)
    return viewController
}()

//MARK: Add Controller as Subview
/**
 Called When need to add a Controller as Subview
 - parameter viewController : Controller to be added as Subview
 */
private func add(asChildViewController viewController: UIViewController)
{
    // Configure Child View
    viewController.view.frame = CGRect(x: 0, y: 0, width: self.baseContainerView.frame.size.width, height: self.baseContainerView.frame.size.height)
    
    // Add Child View Controller
    addChildViewController(viewController)
    viewController.view.translatesAutoresizingMaskIntoConstraints = true
    
    // Add Child View as Subview
    baseContainerView.addSubview(viewController.view)
    
    // Notify Child View Controller
    viewController.didMove(toParentViewController: self)
}

//MARK: Remove Controller as Subview
/**
 Called When need to Remove a Controller as Subview
 - parameter viewController : Controller to be Removed as Subview
 */
private func remove(asChildViewController viewController: UIViewController)
{
    // Notify Child View Controller
    viewController.willMove(toParentViewController: nil)
    
    baseContainerView.willRemoveSubview(viewController.view)
    
    // Remove Child View From Superview
    viewController.view.removeFromSuperview()
    
    // Notify Child View Controller
    viewController.removeFromParentViewController()
}
