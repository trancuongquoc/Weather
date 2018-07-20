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
    var todaySummary: String = ""
    var temp_f: Float = 0
    var temp_c: Int {
        get {
            return Int((temp_f - 32) / 1.8)
        }
    }
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
        let todaySummary = daily["summary"] as! String
        let dailyData = daily["data"] as! [DICT]
        for singleDay in dailyData {
            let singleDayData = SingleDayData(dict: singleDay)
            self.singleDayDataPack.append(singleDayData)
        }
        
        self.lat = lat
        self.long = long
        self.summary = summary
        self.todaySummary = todaySummary
        self.temp_f = temperture
    }
}

class SingleDayData {
    var time: TimeInterval
    var iconString: String
    var temperatureMax: Float = 0
    var maxTemp_c: Int {
        get {
            return Int((temperatureMax - 32) / 1.8)
        }
    }
    var temperatureMin: Float = 0
    var minTemp_c: Int {
        get {
            return Int((temperatureMin - 32) / 1.8)
        }
    }
    var sunriseTime: TimeInterval
    var sunsetTime : TimeInterval
    var chanceOfRain : Float = 0
    var humidity : Float = 0
    var windSpeed: Float = 0
    var uvIndex : Float = 0

    init(dict: DICT) {
        let time = dict["time"] as! TimeInterval
        let iconString = dict["icon"] as! String
        let temperatureMax = dict["temperatureMax"] as! Float
        let temperatureMin = dict["temperatureMin"] as! Float
        let sunriseTime = dict["sunriseTime"] as! TimeInterval
        let sunsetTime = dict["sunsetTime"] as! TimeInterval
        let chanceOfRain = dict["precipProbability"] as! Float
        let humidity = dict["humidity"] as! Float
        let windSpeed = dict["windSpeed"] as! Float
        let uvIndex = dict["uvIndex"] as! Float
        
        self.time = time
        self.iconString = iconString
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        self.chanceOfRain = chanceOfRain
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.uvIndex = uvIndex
    }
}

class HourlyWeatherData {
    var time: TimeInterval
    var humidity: Int
    var iconString: String = "default"
    var temp_f: Float = 0
    var temp_c: Int {
        get {
            return Int((temp_f - 32) / 1.8)
        }
    }
    
    init(dict: DICT) {
        let time = dict["time"] as! TimeInterval
        let humidity = dict["humidity"] as! Float
        let iconString = dict["icon"] as! String
        let temperature = dict["temperature"] as! Float
        
        self.time = time
        self.humidity = Int(humidity * 100)
        self.iconString = iconString
        self.temp_f = temperature
    }
}
