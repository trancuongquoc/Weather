//
//  TimeIntervalConverter.swift
//  Weather
//
//  Created by quoccuong on 7/18/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit
extension TimeInterval {
    func unixToDateString(dateFormatterDesired: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:Locale.current.identifier)
        dateFormatter.dateFormat = dateFormatterDesired
        return dateFormatter.string(from: date)
    }
    
    var sunriseString: String {
        get {
            return self.unixToDateString(dateFormatterDesired: "HH:MM")
        }
    }
    
    var sunsetString : String {
        get {
            return self.unixToDateString(dateFormatterDesired: "HH:MM")
        }
    }
}

