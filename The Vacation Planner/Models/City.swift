//
//  City.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

struct City : Decodable {
    
    var woeid: String
    var district: String
    var province: String
    var stateAcronym: String
    var country: String
    
}
