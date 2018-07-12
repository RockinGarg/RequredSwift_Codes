//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Extension for String
extension String {
    //MARK: Append a New Line in Present Line
    /**
     **Extesnion to append a line to a existing Line**
     */
    func appendLineToURL(fileURL: URL) throws
    {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    //MARK: Append a String to URL
    /**
     **Extesnion to append a line to a existing URL**
     */
    func appendToURL(fileURL: URL) throws
    {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}
//MARK:- Extension for File data
extension Data {
    //MARK: Append New Data
    /**
     **Extesnion to append data in a url**
     */
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path)
        {
            defer
            {
                fileHandle.closeFile()
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else
        {
            try write(to: fileURL, options: .atomic)
        }
    }
}

//MARK:- CSV File Handler
extension DetailTableView
{
    // MARK: Updating CSV file values
    /**
     Function to update values or to append a new row in csv file
     - parameter filename: Always input here is mitocalc
     - returns: Updated CSV
     */
    func updateCsvFile(filename: String) -> Void
    {
        //Name for file
        let fileName = "\(filename).csv"
        
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        //Loop to save array //details below header
        for detail in DetailArray
        {
            let newLine = "\(detail.RecordString),\(detail.Name),\(detail.Date),\(detail.time),\(detail.FqMyDietOutput),\(detail.CaloriesMyDietOutput),\(detail.FatMyDietOutput),\(detail.FqMaintDietOutput),\(detail.CaloriesMaintDietOutput),\(detail.FatMaintDietOutput),\(detail.ProteinsOutput),\(detail.netCarbsOutput),\(detail.WeightSliderVal),\(detail.BodyFatSliderVal),\(detail.ActivitySliderVal),\(detail.ProteinSliderVal),\(detail.DietSliderVal),\(detail.FatsSliderVal),\(detail.RMSSDSliderVal),\(detail.BGSliderVal),\(detail.ProteinSliderLabelVal),\(detail.DietSliderLabelVal),\(detail.FatsSliderLabelVal),\(detail.AFI),\(detail.FQI),\(detail.userAppleID)\n"
            
            //Saving handler
            do
            {
                //save
                WrapperClass.saveLastArrayRecordInDefaultsForReference(ArrayValue: newLine)
                try newLine.appendToURL(fileURL: path!)
                showToast(message: "Record is saved")
            }
            catch
            {
                //if error exists
                print("Failed to create file")
                print("\(error)")
            }
            
            print(path ?? "not found")
        }
        //removing all arrays value after saving data
        DetailArray.removeAll()
    }
    
    // MARK: CSV file creating
    /**
     Function to Create a new CSV File
     - parameter filename: Always input here is mitocalc
     - returns: Updated CSV
     */
    func creatCSV(filename: String) -> Void
    {
        //Name for file
        let fileName = "\(filename).csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        //Headers for file
        var csvText = "RecordString,Name,Date,Time,FqMyDietOutput,CaloriesMyDietOutput,FatsMyDietOutput,FqMaintDietOutput,CaloriesMaintDietOutput,FatsMaintDietOutput,ProteinsOutput,netCarbsOutput,WeightSliderVal,BodyFatSliderVal,ActivitySliderVal,ProteinSliderVal,DietSliderVal,FatsSliderVal,RMSSDSliderVal,BGSliderVal,ProteinSliderLabelVal,DietSliderLabelVal,FatsSliderLabelVal,AFI,FQI,AppleID\n"
        
        //Loop to save array //details below header
        for detail in DetailArray
        {
            let newLine = "\(detail.RecordString),\(detail.Name),\(detail.Date),\(detail.time),\(detail.FqMyDietOutput),\(detail.CaloriesMyDietOutput),\(detail.FatMyDietOutput),\(detail.FqMaintDietOutput),\(detail.CaloriesMaintDietOutput),\(detail.FatMaintDietOutput),\(detail.ProteinsOutput),\(detail.netCarbsOutput),\(detail.WeightSliderVal),\(detail.BodyFatSliderVal),\(detail.ActivitySliderVal),\(detail.ProteinSliderVal),\(detail.DietSliderVal),\(detail.FatsSliderVal),\(detail.RMSSDSliderVal),\(detail.BGSliderVal),\(detail.ProteinSliderLabelVal),\(detail.DietSliderLabelVal),\(detail.FatsSliderLabelVal),\(detail.AFI),\(detail.FQI),\(detail.userAppleID)\n"
            //save last record
            WrapperClass.saveLastArrayRecordInDefaultsForReference(ArrayValue: newLine)
            csvText.append(newLine)
        }
        //Saving handler
        do
        {
            //save
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            showToast(message: "Record is saved")
        }
        catch
        {
            //if error exists
            print("Failed to create file")
            print("\(error)")
        }
        
        //removing all arrays value after saving data
        DetailArray.removeAll()
        print(path ?? "not found")
    }
}
