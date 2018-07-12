//
//  timeSlotsCode.swift
//  serivceApp-Components
//
//  Created by IosDeveloper on 15/05/18.
//  Copyright © 2018 rockinGarg. All rights reserved.
//

import UIKit

class timeSlotsCode: UIViewController {
    
    struct Person: Codable {
        var name: String
    }
    
    struct LoggedUser {
        /// Name
        static var name : String?
        /// Login Social User id
        static var id : String?
        /// Email by which user did Logged
        static var email : String?
    }
    
    

    @IBOutlet weak var minTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    
    
    @IBOutlet weak var mainTimePicker: UIDatePicker!{
        didSet{
            mainTimePicker.locale = Locale.current
            mainTimePicker.isEnabled = false
            mainTimePicker.timeZone = TimeZone.current
        }
    }
    
    private var minTimeSelected : Date?
    private var maxTimeSelected : Date?
    private var isMinTimeToBeSelected : Bool?
    private var slotsArray : [Date]?
    private var tempMinDate : Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTimePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        self.saveStructInDefaults()
        self.getSavedData()
        
        
    }
    
    func saveStructInDefaults(){
        let taylor = Person(name: "DemoName")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(taylor) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPerson")
        }
    }
    
    func getSavedData(){
        if let savedPerson = UserDefaults.standard.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(Person.self, from: savedPerson) {
                print(loadedPerson.name)
            }
        }
    }
}



extension timeSlotsCode
{
    @IBAction func selectMinTime(_ sender: UIButton) {
        self.mainTimePicker.isEnabled = true
        self.mainTimePicker.minimumDate = nil
        self.isMinTimeToBeSelected = true
    }
    
    @IBAction func selectMaxTime(_ sender: UIButton) {
        self.mainTimePicker.isEnabled = true
        let fiftenMinTimeInterval = TimeInterval(60*15)
        self.mainTimePicker.minimumDate = self.minTimeSelected!.addingTimeInterval(fiftenMinTimeInterval)
        self.isMinTimeToBeSelected = false
    }
    
    @IBAction func getTimeSlots(_ sender: UIButton) {
        slotsArray = [Date]()
        slotsArray?.append(minTimeSelected!)
        self.timeSlotsDivide(minTime: minTimeSelected!, MaxTime: maxTimeSelected!)
    }
    
    @IBAction func pickerDoneBtnAction(_ sender: UIButton) {
        self.mainTimePicker.isEnabled = false
        
    }
}

extension timeSlotsCode
{
    @objc func timeChanged(_ sender: UIDatePicker) {
        print(sender.date)
        if isMinTimeToBeSelected! {
            /// Update Minimum Val
            self.minTimeSelected = sender.date
            self.minTimeLabel.text = self.getDateFormatted(date: sender.date)
        }
        else{
            /// Update Max Val
            self.maxTimeSelected = sender.date
            self.maxTimeLabel.text = self.getDateFormatted(date: sender.date)
        }
    }
    
    func getDateFormatted(date:Date) -> String {
        let DF = DateFormatter()
        // change to a readable time format and change to local time zone
        DF.dateFormat = "h:mm a"
        DF.timeZone = TimeZone.current
        return DF.string(from: date)
    }
    
    func timeSlotsDivide(minTime:Date,MaxTime:Date){
        let fiftenMinTimeInterval = TimeInterval(60*15)
        tempMinDate = minTime.addingTimeInterval(fiftenMinTimeInterval)
        if tempMinDate! < MaxTime {
            /// can Add Values
            slotsArray?.append(tempMinDate!)
            timeSlotsDivide(minTime: tempMinDate!, MaxTime: maxTimeSelected!)
        }
        else{
            /// Max Slot Divided
            for i in 0..<(slotsArray?.count)! {
                print("date index:\(i) convertedDate:\(getDateFormatted(date: slotsArray![i]))")
            }
            return
        }
    }
}
