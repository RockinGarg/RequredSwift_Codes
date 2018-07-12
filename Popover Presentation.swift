//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

class onScreenCodes: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "scrollViewDrag") as? scrollViewDrag
        vc?.modalPresentationStyle = .popover
        vc?.preferredContentSize = CGSize(width: 180, height: 75)
        
        let popover = vc!.popoverPresentationController!
        popover.sourceView = self.openMapButton
        popover.sourceRect = self.openMapButton.bounds
        popover.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection)  -> UIModalPresentationStyle {
            return .none
    }
}
