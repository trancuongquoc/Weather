//
//  DataServices.swift
//  Weather
//
//  Created by quoccuong on 7/9/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import Foundation

class DataServices {
    
    static func loadWeather(complete: @escaping(WeatherObject) -> Void) {
        
        let url = URL(string: "https://api.darksky.net/forecast/0a7e919279ef03e2c1bb23c71544d118/21.028511,%20105.804817")!
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let aData = data else { return }
            
            do {
                let result = try JSONSerialization.jsonObject(with: aData, options: .mutableContainers)
                guard let object = result as? DICT else { return }
                
                let weatherObject = WeatherObject(dict: object)
                DispatchQueue.main.async {
                    complete(weatherObject!)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
