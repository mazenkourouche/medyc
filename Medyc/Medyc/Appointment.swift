//
//  Appointment.swift
//  Clinical Tracker
//
//  Created by Mazen Kourouche on 19/04/2016.
//  Copyright © 2016 Mazen Kourouche. All rights reserved.
//

import Foundation

class Appointment: NSObject, NSCoding {
    
    var name: String = ""
    var date: Date = Date()
    var location: String = ""
    var phone: String = ""
    var notes: String = ""
    var addedToCalendar: Bool = false
    
    init (name: String, date: Date, location: String, phone: String, notes: String, addedToCalendar: Bool) {
        self.name = name
        self.date = date
        self.location = location
        self.phone = phone
        self.notes = notes
        self.addedToCalendar = addedToCalendar
        
    }
    
    override init() {
        self.name = String()
        self.date = Date()
        self.location = String()
        self.phone = String()
        self.notes = String()
        self.addedToCalendar = false
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let location = aDecoder.decodeObject(forKey: "location") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        let notes = aDecoder.decodeObject(forKey: "notes") as! String
        let addedToCalendar = aDecoder.decodeBool(forKey: "addedToCalendar")
        
        self.init(name: name, date: date as Date, location: location, phone: phone, notes: notes, addedToCalendar: addedToCalendar)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(addedToCalendar, forKey: "addedToCalendar")
    }
    
    
}
