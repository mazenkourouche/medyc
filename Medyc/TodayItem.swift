//
//  TodayItem.swift
//  Medyc
//
//  Created by Mazen Kourouche on 27/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import Foundation

class TodayItem: NSObject {
    
    var name = String()
    var date = Date ()
    var index = Int()
    var type = String()
    
    init (name: String, date: Date, index: Int, type: String) {
        self.name = name
        self.date = date
        self.index = index
        self.type = type
    }
    
}
