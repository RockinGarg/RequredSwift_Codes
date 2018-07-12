//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//MARK:- Upload Status - Protocol
/**
 This Protocol is used to get the required data from Upload Data class
 */
protocol uploadDataProtocol {
    //MARK: Get Uploading progress
    /**
     This Function is used to check how much percent of file is Uploaded to server
     - parameter progress : Progress Status in Double
     */
    func finalProgressStatus(progress:Double)
}

//MARK:- Upload Status - Protocol
/**
 This Class is used to Upload a type of File to server and Types Supported Are:
 - Video: video/mov
 - PDF: application/pdf
 - Image: image/jpeg
 */
class uploadData: NSObject
{
    /// Delegate Object
    static var delegate : uploadDataProtocol?

    class func imageDataToServer(parameters: [String : AnyObject],_ finalData: Data,_ filename: String, _ mimeType: String,_ baseURL: String, success:@escaping ([String:Any]) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            /// For multiple Just Pass Data Array and MimeType Array
            /// And
            multipartFormData.append(finalData, withName: "file", fileName: filename, mimeType: mimeType)
            /// Copy Above line in a For loop to attach Multiple Data in Multipart
            /// Rest All Same
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: baseURL, method: .post,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_,_):
                
                upload.responseJSON { (response:DataResponse<Any>) in
                    if response.result.isSuccess {
                        /// Final Response
                        let jsonDict = response.result.value as! [String:Any]
                        print(jsonDict)
                        success(jsonDict)
                    }
                    else {
                        /// Error Occurred
                        let error : Error = response.result.error! as Error
                        failure(error)
                    }
                }
                upload.uploadProgress(closure: {
                    progress in
                    /// Get the Upload Progress Status
                    delegate?.finalProgressStatus(progress: progress.fractionCompleted)
                })
            case .failure(let encodingError):
                /// Failure case
                failure(encodingError)
            }
        })
    }
}

//USage

//MARK:- API Handlers
extension SignUp: uploadDataProtocol
{
    
    //MARK: Resize Image - Sizer
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //MARK: Document as Data
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
    
    //MARK: Get Uploading progress
    /**
     This Function is used to check how much percent of file is Uploaded to server
     - parameter progress : Progress Status in Double
     */
    func finalProgressStatus(progress: Double) {
        Functions.shared.changeLoaderLabelText("Uploading \(Int(progress*100))%", baseController!)
    }
    
    //MARK: Upload Doucment
    /**
     This Function is used to upload The document on server
     - parameter finalData : Dictionary Data which is to be uploaded on Server
     */
    private func uploadDocumentWithURL(_ finalData: [String:Any]){
        uploadData.delegate = self
        Functions.shared.showActivityIndicator("Uploading", view: baseController!)
        uploadData.imageDataToServer(parameters: [:], finalData["data"] as! Data, finalData["name"] as! String, finalData["mimeType"] as! String, "\(Env.baseURL)uploadFile", success: { (jsonDict) in
            print("jsonDict Upload Document:\(jsonDict)")
            var valueDict = finalData
            valueDict["uploadedURL"] = jsonDict["data"]
            globalArrays.documentDataDictArray?.append(valueDict)
            self.documentTableView.reloadData()
            self.delegate?.reloadSignUpViews()
            Functions.shared.hideActivityIndicator()
            print(globalArrays.documentDataDictArray ?? [])
        }) { (error) in
            Functions.shared.hideActivityIndicator()
            self.baseController?.BasicAlert("Service Provider App", message: error.localizedDescription, view: self.baseController!)
        }
    }
}




