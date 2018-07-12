//
//  Weather.swift
//  Weather
//
//  Created by quoccuong on 7/9/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import Foundation

typealias DICT = Dictionary<AnyHashable,Any>

class WeatherObject {
    var location_name: String = ""
    var currentWeather: CurrentWeather
    
    init(dict: DICT) {
        let location = dict["location"] as! DICT
        let location_name = location["name"] as! String
        let currentWeather = dict["current"] as!  DICT
        
        self.location_name = location_name
        self.currentWeather = CurrentWeather(dict: currentWeather)
    }
}
class CurrentWeather {
    var temp_c: Float = 0
    var temp_f: Float = 0
    
    init(dict: DICT) {
        let temp_c = dict["temp_c"] as! Float
        let temp_f = dict["temp_f"] as! Float
        
        self.temp_c = temp_c
        self.temp_f = temp_f
    }
}
