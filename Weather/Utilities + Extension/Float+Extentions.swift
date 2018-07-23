//
//  Float+Extentions.swift
//  Weather
//
//  Created by quoccuong on 7/23/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import Foundation

extension Float {
    
    var chainceOfRainString: String {
        get {
            let chanceOfRainString = "\(Int(self * 100))" + "%"
            return chanceOfRainString
        }
    }
    
    var todayTempMaxString : String {
        get {
            let todayTempMax = (self - 32) / 1.8
            let result = Int(todayTempMax)
            return "\(result)"
        }
    }
    
    var todayTempMinString : String {
        get {
            let todayTemp_cMin = Int((self - 32) / 1.8)
            return "\(todayTemp_cMin)"
        }
    }
    
    var humidityString: String {
        get {
            let humidityString = "\(Int(self * 100))" + "%"
            return humidityString
        }
    }
    
    var windSpeedString : String {
        return "\(Int(self))" + "kph"
    }
    
    var uvIndexString : String {
        return "\(self)"
    }
}
