//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Document Directory Code
extension SwiftCodes
{
    //MARK: Save File
    /**
     * Usage - getDocumentsDirectory().appendingPathComponent("\(audioName).wav")
     */
    func getDocumentsDirectory() -> URL
    {
        //Get Basic URL
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        /// Enter a Directory Name in which files will be saved
        let dataPath1 = documentsDirectory.appendingPathComponent("folder_name_enter")
        let dataPath = dataPath1.appendingPathComponent("folder inside directory if required (name)")
        //Handler
        do
        {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return dataPath
    }
    
    //MARK: Remove Files
    /**
     * Directly Call this function
     */
    func clearAllFilesFromTempDirectory()
    {
        let fileManager = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let tempDirPath = dirPath.appending("/folder_name/\(inside_directoryName)")
        
        do {
            let folderPath = tempDirPath
            let paths = try fileManager.contentsOfDirectory(atPath: tempDirPath)
            for path in paths
            {
                try fileManager.removeItem(atPath: "\(folderPath)/\(path)")
            }
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
}

