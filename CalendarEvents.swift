//
//  ViewController.swift
//  CalenderEvent
//
//  Created by IosDeveloper on 11/04/18.
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var savedEventId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addEvent(){
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            let event = EKEvent(eventStore: store)
            event.title = "Jatinn"
            event.startDate = Date() //today
            event.endDate = event.startDate.addingTimeInterval(60*60)//1 hour long meeting
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.save(event, span: .thisEvent, commit: true)
                self.savedEventId = event.eventIdentifier //save event id to access this particular event later
            } catch {
                // Display error to user
            }
        }
    }
    
    func removeEvent(){
        let store = EKEventStore()
        store.requestAccess(to: EKEntityType.event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.event(withIdentifier: self.savedEventId!)
            if eventToRemove != nil {
                do {
                    try store.remove(eventToRemove!, span: .thisEvent, commit: true)
                } catch {
                    // Display error to user
                }
            }
        }
    }
}

