//
//  WeatherForecast.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

class WeatherForecast {
    
    var date: String
    var temperature: Temperature
    var weather: String
    var woeid: String
    
    init(date: String, temperature: Temperature, weather: String, woeid: String) {
        self.date = date
        self.temperature = temperature
        self.weather = weather
        self.woeid = woeid
    }
    
}
