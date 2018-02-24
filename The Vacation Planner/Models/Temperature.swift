//
//  Temperature.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

class Temperature {
    
    var max: Int
    var min: Int
    var unit: String
    
    init(max: Int, min: Int, unit: String) {
        self.max = max
        self.min = min
        self.unit = unit
    }
    
}
