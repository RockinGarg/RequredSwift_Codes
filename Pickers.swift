//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Document Controller
extension SignUp: UIDocumentPickerDelegate
{
    //MARK: Pick Document
    /**
     This function is used to Load document Picker
     */
    func documentPicker() {
        let documentPicker = UIDocumentPickerViewController.init(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        baseController?.present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: Error - Enum
    /**
     This Enum is used for Do Try Handler block to return a Error Description
     */
    enum MyError: Error {
        case FoundNil(String)
    }
    
    //MARK: Did Pick Document
    /**
     Tells the delegate that the user has selected a document or a destination
     - parameter controller: The document picker that called this method
     - parameter didPickDocumentAt: The URL of the selected document
     */
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        baseController?.dismiss(animated: true, completion: nil)
        do {
            let newData = try! Data.init(contentsOf: url)
            if newData.isEmpty {
                throw MyError.FoundNil("File could not be converted in Data Format, Please try")
            }
            else{
                let newDict : [String:Any] = ["type":"document","data":newData,"name":url.lastPathComponent,"image":UIImage.init(named: "documentType") ?? #imageLiteral(resourceName: "documentType"),"uploadedURL":"","mimeType":"application/pdf"]
                //globalArrays.documentDataDictArray?.append(newDict)
                DispatchQueue.main.async {
                    print((globalArrays.documentDataDictArray)!)
                    //self.documentTableView.reloadData()
                    
                    self.uploadDocumentWithURL(newDict)
                }
                
                //self.documentTableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: true)
            }
        }
        catch {
            baseController?.BasicAlert("Service Provider App", message: error.localizedDescription, view: baseController!)
        }
        
        //self.documentTableView.reloadData()
    }
    //MARK: Picker Selection Cancelled
    /**
     Tells the delegate that the user canceled the document picker
     - parameter controller: The document picker that called this method
     */
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        baseController?.dismiss(animated: true, completion: nil)
    }
}

//MARK:- ImagePicker Extension
extension SignUp: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{    
    /*
     <key>NSCameraUsageDescription</key>
     <string>Allow $(PRODUCT_NAME) to use Camera</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>Allow $(PRODUCT_NAME) to Access Photos in your iPhone</string>
   */
    //MARK: Document Selection Action Sheet
    func createActionSheet()
    {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.mediaTypes = [kUTTypeImage as String]
        ///Show Action Sheet To Give user option to select Among Different options Available
        // Create the AlertController
        let actionSheetController = UIAlertController(title: "Service Provider App", message: "Do you want to Upload Image Or Document", preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and add a second option action
        let documentAction = UIAlertAction(title: "Document", style: .default) { action -> Void in
            self.documentPicker()
        }
        actionSheetController.addAction(documentAction)
        
        // Create and add a third option action
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(cameraAction)
        
        // Create and add a third option action
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            self.openGallary()
        }
        actionSheetController.addAction(galleryAction)
        
        actionSheetController.popoverPresentationController?.sourceView = baseController?.view
        actionSheetController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: (baseController?.view.bounds.midX)!, y: (baseController?.view.bounds.midY)!, width: 0, height: 0)
        
        // Present the AlertController
        baseController?.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: Open Camera
    /**
     This function is used to open Camera for updating profile picture
     */
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker?.allowsEditing = true
            baseController?.present(imagePicker!, animated: true, completion: nil)
        }
        else {
            baseController?.BasicAlert("Service App", message: "No Camera Available", view: baseController!)
        }
    }
    
    //MARK: Open Gallery
    /**
     This function is used to open gallery to select a new profile image
     */
    private func openGallary() {
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker?.allowsEditing = true
        baseController?.present(imagePicker!, animated: true, completion: nil)
    }
    
    //MARK: UIImagePicker Controller Result Delegate
    /**
     Called when user selected a Image or a Movie from Gallery
     - parameter picker : The controller object managing the image picker interface
     - parameter info : A dictionary containing the original image and the edited image,
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker .dismiss(animated: true, completion: nil)
        if picker.sourceType == .camera {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let newDict : [String:Any] = ["type":"image","data":UIImagePNGRepresentation(self.resizeImage(image: image, targetSize: CGSize(width: 600, height: 600)))!,"name":"\(UUID().uuidString).jpeg","image":UIImage.init(named: "pngType") ?? #imageLiteral(resourceName: "pngType"),"uploadedURL":"","mimeType":"image/jpeg"]
                imagePicker = nil
                self.uploadDocumentWithURL(newDict)
            }
            else{
                imagePicker = nil
                baseController?.BasicAlert("Service App", message: "Error While Selecting Image", view: baseController!)
            }
        }
        else{
            /// Get File Name
            if let url = info[UIImagePickerControllerImageURL] as? URL {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let newDict : [String:Any] = ["type":"image","data":UIImagePNGRepresentation(self.resizeImage(image: image, targetSize: CGSize(width: 600, height: 600)))!,"name":url.lastPathComponent,"image":UIImage.init(named: "pngType") ?? #imageLiteral(resourceName: "pngType"),"uploadedURL":"","mimeType":"image/jpeg"]
                    imagePicker = nil
                    self.uploadDocumentWithURL(newDict)
                }
                else {
                    imagePicker = nil
                    baseController?.BasicAlert("Service App", message: "Error While Selecting Image", view: baseController!)
                }
                imagePicker = nil
            }
            else {
                imagePicker = nil
                baseController?.BasicAlert("Service App", message: "Error While Selecting Image", view: baseController!)
            }
        }
    }
    
    //MARK: Picker did Cancel
    /**
     Called when user Cancel the picker
     - parameter picker : The controller object managing the image picker interface
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        baseController?.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
}

//MARK:- UIPickerView
extension infoVC : UIPickerViewDataSource, UIPickerViewDelegate
{
    //MARK: No. of Sections for Picker
    /**
     Called by the picker view when it needs the number of components.
     - parameter pickerView: The picker view requesting the data.
     - returns: Number of sections
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    //MARK: Number of rows for picker
    /**
     Called by the picker view when it needs the number of rows for a specified component.
     - parameter pickerView: The picker view requesting the data.
     - parameter component: A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
     - returns: The number of rows for the component.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return NamesStringArray.count
    }
    
    // MARK: Title or content for row in given component
    /**
     Called by the picker view when it needs the title to use for a given row in a given component.
     - parameter pickerView: The picker view requesting the data.
     - parameter row: Index of row
     - parameter component: component Index
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.selectedRowIndex = 0
        return NamesStringArray[row]
    }
    
    //MARK: Setting title colour
    /**
     Called by Picker to Add attributed text as title
     - parameter pickerView: The picker view requesting the data.
     - parameter row: Index of row
     - parameter component: component Index
     */
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        // Change picker view content color
        let attributedString = NSAttributedString(string: NamesStringArray[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        self.pikcerValueLabel.text = "Record"
        self.selectedRowIndex = row
        return attributedString
    }
    
    //MARK: Setting picker select label size
    /**
     Called by Picker to To add customized text to fit size
     - parameter pickerView: The picker view requesting the data.
     - parameter row: Index of row
     - parameter component: component Index
     */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        /*let data = NamesStringArray[row] //for increasing size of picker label if required
         let title = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.regular)])
         pickerLabel.attributedText = title*/
        
        let pickerLabel = UILabel()
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0;
        pickerLabel.textColor = UIColor.white
        self.selectedRowIndex = row
        pickerLabel.text = NamesStringArray[row]
        pickerLabel.sizeToFit()
        pickerLabel.adjustsFontSizeToFitWidth = true
        self.pikcerValueLabel.text = "Record"
        return pickerLabel
    }
    
    // MARK: Called when row selected from any component within a picker view
    /**
     Called by Picker to Select a specific row
     - parameter pickerView: The picker view requesting the data.
     - parameter row: Index of row
     - parameter component: component Index
     - returns: selected row
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedRowIndex = row
    }
}

