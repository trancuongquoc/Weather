//
//  LocationServices.swift
//  Weather
//
//  Created by quoccuong on 7/24/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class LocationServices {
    
    static func forwardGeocoding(address: String, callback: @escaping (CLLocationCoordinate2D) -> Void) {
    CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
        if error != nil {
            print(error!)
            return
        }
        if (placemarks?.count ?? 0) > 0 {
            let placemark = placemarks?[0]
            let location = placemark?.location
            let coordinate = location?.coordinate
            callback(coordinate!)
            if (placemark?.areasOfInterest?.count ?? 0) > 0 {
                let areaOfInterest = placemark!.areasOfInterest![0]
                print(areaOfInterest)
            } else {
                print("No area of interest found.")
            }
        }
    })
}

    static func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees, callback: @escaping (String?)->Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        if error != nil {
            print(error as Any)
            return
        }
        else if (placemarks?.count ?? 0) > 0 {
            let pm = placemarks![0]
            callback(pm.locality)
            let city = pm.locality
            print("\n\(city ?? "")")
            
        }
    })
}
}
