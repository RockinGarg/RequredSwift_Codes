//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Functions
/**
 This class is used to call all the Required Funtions that are common in classes
 */
class Functions: NSObject {
    //MARK: Alamofire - Get URL
    /**
     This Function is used to get response from API with GET
     - parameter strURL : URL that is to be Hitted
     - parameter params : Parameters That need to be send along API
     - parameter success : This Block Returns Value if response Received from API
     - parameter failure : This Block Returns Value if no response Received from API
     */
    class func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping ([String:Any]) -> Void, failure:@escaping (NSError) -> Void) {
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                //to get status code
                if response.result.isSuccess {
                    print("Response for \(strURL) :\(response.result.value as! NSDictionary)")
                    let resJson = response.result.value as! [String:Any]
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
    }
    
    
    
    //MARK: Alamofire - POST URL
    /**
     This Function is used to get response from API with POST
     - parameter strURL : URL that is to be Hitted
     - parameter params : Parameters That need to be send along API
     - parameter success : This Block Returns Value if response Received from API
     - parameter failure : This Block Returns Value if no response Received from API
     */
    class func requestPOSTURL(_ strURL : String, params : [String : Any]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void) {
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : Error = response.result.error! as Error
                    failure(error)
                }
        }
    }
    
    //MARK: URL Session - Post Method - Param String
    /**
     This Function is used to get response from API with GET
     - parameter strURL : URL that is to be Hitted
     - parameter params : Parameters That need to be send along API
     - parameter success : This Block Returns Value if response Received from API
     - parameter failure : This Block Returns Value if no response Received from API
     
     let newParam : String = "userEmail=\(emailTF.text!)&firstName=\(firstNameTF.text!)&lastName=\(lastNameTF.text!)&password=\(passwordTF.text!)&providerDocuments=\(uploadedDocumentNames!)"
     */
    class func requestPOSTURLWithUrlsession(_ strURL : String, params : String, success:@escaping ([String:Any]) -> Void, failure:@escaping (Error) -> Void) {
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let postData = NSMutableData(data: params.data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: urlwithPercentEscapes!)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                OperationQueue.main.addOperation() {
                    failure(error! as Error)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                OperationQueue.main.addOperation() {
                    failure(error! as Error)
                }
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Any {
                    OperationQueue.main.addOperation()
                        {
                            success(json as Any as! [String:Any])
                    }
                }
            } catch let error {
                OperationQueue.main.addOperation()
                    {
                        failure(error as Error)
                }
            }
        })
        task.resume()
    }
    
    //MARK: URL Session - Post Method - Param Array
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
    }
    
    //MARK: URL Session - GET Method
    class func requestGETWithUrlSession(_ strURL: String, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                failure(error! as NSError)
                print("error")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    // For count
                    success(json as NSDictionary)
                    
                } catch let error as NSError{
                    failure(error)
                }
            }
        }).resume()
    }
}
