//
//  LoginView.swift
//  Service App
//
//  Created by IosDeveloper on 23/04/18.
//  Copyright © 2018 ServiceApp. All rights reserved.
//

import UIKit

//MARK:- LoginView
/**
 This Class is used to show a common View for Login Process
 */
class LoginView: UIView
{
    //MARK: UIView
    /// content View of login View Xib
    @IBOutlet var contentView: UIView!
    
    //MARK: Init Class
    /**
     This function is used to Initialise the class
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
 
    //MARK: Encoder
    /**
     This function is used to Store the class objects added
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    //MARK: Dienit class
    /**
     This function is used to De-Allocate the class objects
     */
    deinit {
        /// Remove all The Initiated Instances
    }
}

//MARK:- Required Methods
extension LoginView
{
    //MARK: Load Nib
    /**
     This function is used to load the Nib from Bundle
     */
    func loadNib() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: [:])
        // 2. Adding the 'contentView' to self (self represents the instance of a WeatherView which is a 'UIView').
        addSubview(contentView)
        // 3. Setting this false allows us to set our constraints on the contentView programtically
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        // 4. Setting the constraints programatically
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

//MARK: Usage in Main Controller

/// Login XIB Class Reference
private var loginXib : LoginView?


//MARK: Load Login XIB
/**
 This function is used to add Login XIB in View Memory
 */
private func loadLoginXib() {
    if loginXib == nil {
        self.loginXib = LoginView.init(frame: CGRect(x: 0, y: self.xibBaseView.frame.size.height*0.07, width: self.xibBaseView.frame.size.width, height: self.xibBaseView.frame.size.height-(self.xibBaseView.frame.size.height*0.07)))
        self.loginXib?.delegate = self
        self.xibBaseView.addSubview(self.loginXib!)
    }
}
