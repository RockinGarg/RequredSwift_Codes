//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

/// Bool to check can make use of Scan Card Option ?
private var canUseCardIO : Bool?

/// Card IO View Controller class Object
private var cardIOPaymentVCViewObject : CardIOPaymentViewController?

//MARK: View Did Load
/**
 Called after the controller's view is going to be loaded into memory
 */
override func viewDidLoad() {
    super.viewDidLoad()
    canUseCardIO = false
    CardIOUtilities.preload()
}

//MARK: View Will Appear
/**
 Called after the controller's view is getting loaded into memory
 */
override func viewWillAppear(_ animated: Bool) {
    CardIOUtilities.canReadCardWithCamera() ? (canUseCardIO = true) : (canUseCardIO = false)
}

//MARK: Scan Card
/**
 This is used to Scan A Card
 - parameter sender : Button Tag
 */
@IBAction func scanCardBtnAction(_ sender: UIButton) {
    if canUseCardIO! {
        cardIOPaymentVCViewObject = CardIOPaymentViewController(paymentDelegate: self)
        self.present(cardIOPaymentVCViewObject!, animated: true, completion: nil)
    }
    else{
        self.BasicAlert("Service App", message: "Can not use this Option", view: self)
    }
}

//MARK:- Card.Io Delegates
extension cardPaymentVC : CardIOPaymentViewControllerDelegate
{
    //MARK: Get Stripe Token
    /**
     This function is used to get a Card Token for payment
     - parameter card : STPCardParams - All details about a Card
     */
    func getStripeToken(card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            if let token = token {
                print("token:\(token)")
            }
            else {
                print("Error While Getting Token:\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    //MARK: Cancelled Scanning
    /**
     Delegate called when User Cancelled scanning of Card
     - parameter paymentViewController : CardIOPaymentViewController Reference
     */
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        print("Scanning Card is Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
        self.cardIOPaymentVCViewObject = nil
    }
    
    //MARK: Card Scanned
    /**
     Delegate called when User Successfully scanning of Card
     - parameter cardInfo : Dictionary with Fetched Results from a Card
     - parameter paymentViewController : CardIOPaymentViewController Reference
     */
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        splittedArray = [String]()
        print("Card Info fetched:\(cardInfo)")
        splittedArray = cardInfo.cardNumber.splitByLength(4)
        cardNum1TF.text = splittedArray![0]
        cardNum2TF.text = splittedArray![1]
        cardNum3TF.text = splittedArray![2]
        
        //create Stripe card
        let card: STPCardParams = STPCardParams()
        card.number = cardInfo.cardNumber
        card.expMonth = cardInfo.expiryMonth
        card.expYear = cardInfo.expiryYear
        card.cvc = cardInfo.cvv
        
        paymentViewController.dismiss(animated: true, completion: nil)
        self.cardIOPaymentVCViewObject = nil
    }
}
