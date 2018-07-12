//
//  Weather.swift
//  Weather
//
//  Created by quoccuong on 7/9/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit

typealias DICT = Dictionary<AnyHashable,Any>

class WeatherObject {
    var lat: Float = 21.028511
    var long: Float = 105.804817
    
    //dict[currently]
    var summary: String = ""
    var temperature: Float = 0
    
    var singleDayDataPack = [SingleDayData]()
    var singleHourDataPack = [HourlyWeatherData]()
    init?(dict: DICT) {
        //object dict
        let lat = dict["latitude"] as! Float
        let long = dict["longitude"] as! Float
        
        let currently = dict["currently"] as! DICT
        // dict[currently]
        let summary = currently["summary"] as! String
        let temperture = currently["temperature"] as! Float
        
        let hourly = dict["hourly"] as! DICT
        //dict[hourly]
        let hourlyData = hourly["data"] as! [DICT]
        for singleHour in hourlyData {
            let singleHourData = HourlyWeatherData(dict: singleHour)
            singleHourDataPack.append(singleHourData)
        }
        
        
        let daily = dict["daily"] as! DICT
        let dailyData = daily["data"] as! [DICT]
        for singleDay in dailyData {
            let singleDayData = SingleDayData(dict: singleDay)
            self.singleDayDataPack.append(singleDayData)
        }
        
        self.lat = lat
        self.long = long
        self.summary = summary
        self.temperature = temperture
    }
}

class SingleDayData {
    var time: TimeInterval
    var temperatureMax: Float = 0
    var temperatureMin: Float = 0
    
    init(dict: DICT) {
        let time = dict["time"] as! TimeInterval
        let temperatureMax = dict["temperatureMax"] as! Float
        let temperatureMin = dict["temperatureMin"] as! Float
        
        self.time = time
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
    }
}

class HourlyWeatherData {
    var time: TimeInterval
    var iconString: String = "default"
    var temperature: Float = 0
    
    init(dict: DICT) {
        let time = dict["time"] as! TimeInterval
        let iconString = dict["icon"] as! String
        let temperature = dict["temperature"] as! Float
        
        self.time = time
        self.iconString = iconString
        self.temperature = temperature
    }
}
