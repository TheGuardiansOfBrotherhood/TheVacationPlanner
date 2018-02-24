//
//  City.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

class City {
    
    var woeid: String
    var district: String
    var province: String
    var stateAcronym: String
    var country: String
   
    init(woeid: String, district: String, province: String, stateAcronym: String, country: String) {
        self.woeid = woeid
        self.district = district
        self.province = province
        self.stateAcronym = stateAcronym
        self.country = country
    }
    
}
