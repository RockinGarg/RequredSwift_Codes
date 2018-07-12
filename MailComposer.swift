//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- MFMail Composer
extension SwiftCodes : MFMailComposeViewControllerDelegate
{
    //MARK: Configuring email
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["info@mitokinetics.com"])
        mailComposerVC.setSubject("MitoCalc Request")
        if (WrapperClass.FileExists()) {
            // locate folder containing pdf file
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            let pdfFileName = (documentsPath as NSString).appendingPathComponent("mitocalc.csv")
            let fileData = NSData(contentsOfFile: pdfFileName)
            mailComposerVC.addAttachmentData(fileData! as Data, mimeType: "text/csv", fileName: "mitocalc.csv")
        }
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Usage
    @IBAction func composeMailBtnAction(_ sender: Any)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else{ }
    }
}
