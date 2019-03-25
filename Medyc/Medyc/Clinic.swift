//
//  Clinic.swift
//  Clinical Tracker
//
//  Created by Mazen Kourouche on 14/07/2016.
//  Copyright © 2016 Mazen Kourouche. All rights reserved.
//

import Foundation
import CoreLocation

class Clinic: NSObject, NSCoding {
    

    
    var name: String = ""
    var location: String = ""
    var formattedLocation: String = ""
    var suburb: String = ""
    var phone: String = ""
    var url: String = ""
    var distance = ""
    var duration = ""
    var latitude = ""
    var longitude = ""
    
    
    init (name: String, location: String, formattedLocation: String, suburb: String, phone: String, url: String, distance: String, duration: String, latitude: String, longitude: String) {
        
        self.name = name
        self.location = location
        self.formattedLocation = formattedLocation
        self.suburb = suburb
        self.phone = phone
        self.url = url
        self.distance = distance
        self.duration = duration
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: "clinicName") as? String
        let location = aDecoder.decodeObject(forKey: "clinicLocation") as? String
        let formattedLocation = aDecoder.decodeObject(forKey: "clinicFormattedLocation") as? String
        var suburb = aDecoder.decodeObject(forKey: "clinicSuburb") as? String
        let phone = aDecoder.decodeObject(forKey: "clinicPhone") as? String
        let url = aDecoder.decodeObject(forKey: "clinicURL") as? String
        let duration = aDecoder.decodeObject(forKey: "clinicDuration") as? String
        let distance = aDecoder.decodeObject(forKey: "clinicDistance") as? String
        let latitude = aDecoder.decodeObject(forKey: "clinicLatitude") as? String
        let longitude = aDecoder.decodeObject(forKey: "clinicLongitude") as? String
        
        
        
        self.init(name: name!, location: location!, formattedLocation: formattedLocation!, suburb: suburb!, phone: phone!, url: url!, distance: distance!, duration: duration!, latitude: latitude!, longitude: longitude!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "clinicName")
        aCoder.encode(location, forKey: "clinicLocation")
        aCoder.encode(location, forKey: "clinicFormattedLocation")
        aCoder.encode(suburb, forKey: "clinicSuburb")
        aCoder.encode(phone, forKey: "clinicPhone")
        aCoder.encode(url, forKey: "clinicURL")
        aCoder.encode(duration, forKey: "clinicDuration")
        aCoder.encode(distance, forKey: "clinicDistance")
        aCoder.encode(latitude, forKey: "clinicLatitude")
        aCoder.encode(longitude, forKey: "clinicLongitude")
        
    }
    
   
}
