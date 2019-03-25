//
//  Medication.swift
//  Clinical Tracker
//
//  Created by Mazen Kourouche on 19/04/2016.
//  Copyright © 2016 Mazen Kourouche. All rights reserved.
//

import Foundation

class Medication: NSObject, NSCoding {
    
    var medName: String = ""
    var totalDosages: Int = 0
    var dailyDosages: Int = 0
    var requiredIntervals: String = ""
    var dosesTakenToday: Int = 0
    var dateLogged: Date = Date()
    var nextDose: Date = Date()
    var medicationID: String = ""
    
    init (medName: String, totalDosages: Int, dailyDosages: Int, requiredIntervals: String, dosesTakenToday: Int, dateLogged: Date, nextDose: Date, medicationID: String) {
        
        self.medName = medName
        self.totalDosages = totalDosages
        self.dailyDosages = dailyDosages
        self.requiredIntervals = requiredIntervals
        self.dosesTakenToday = dosesTakenToday
        self.dateLogged = dateLogged
        self.nextDose = nextDose
        self.medicationID = medicationID
        
    }
    
    
    override init() {
        self.medName = String()
        self.totalDosages = Int()
        self.dailyDosages = Int()
        self.requiredIntervals = String()
        self.dosesTakenToday = Int()
        self.dateLogged = Date()
        self.nextDose = Date()
        self.medicationID = String()
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let medName = aDecoder.decodeObject(forKey: "medName") as! String
        let totalDosages = aDecoder.decodeCInt(forKey: "totalDosages")
        let dailyDosages = aDecoder.decodeCInt(forKey: "dailyDosages")
        let requiredIntervals = aDecoder.decodeObject(forKey: "requiredIntervals") as! String
        let dosesTakenToday = aDecoder.decodeCInt(forKey: "dosesTakenToday")
        let dateLogged = aDecoder.decodeObject(forKey: "dateLogged") as! Date
        let nextDose = aDecoder.decodeObject(forKey: "nextDose") as! Date
        let medicationID = aDecoder.decodeObject(forKey: "medicationID") as! String
        
        self.init(medName: medName, totalDosages: Int(totalDosages), dailyDosages: Int(dailyDosages), requiredIntervals: requiredIntervals, dosesTakenToday: Int(dosesTakenToday), dateLogged: dateLogged, nextDose: nextDose, medicationID: medicationID)
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(medName, forKey: "medName")
        aCoder.encodeCInt(Int32(totalDosages), forKey: "totalDosages")
        aCoder.encodeCInt(Int32(dailyDosages), forKey: "dailyDosages")
        aCoder.encode(requiredIntervals, forKey: "requiredIntervals")
        aCoder.encodeCInt(Int32(dosesTakenToday), forKey: "dosesTakenToday")
        aCoder.encode(dateLogged, forKey: "dateLogged")
        aCoder.encode(nextDose, forKey: "nextDose")
        aCoder.encode(medicationID, forKey: "medicationID")
        
    }
}
