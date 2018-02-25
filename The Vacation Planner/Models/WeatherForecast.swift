//
//  WeatherForecast.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

struct WeatherForecast : Decodable {

    var date: String
    var temperature: Temperature
    var weather: String
    var woeid: String

}
