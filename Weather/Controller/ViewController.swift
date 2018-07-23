//
//  ViewController.swift
//  Weather
//
//  Created by quoccuong on 7/9/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var todayTempMaxLabel: UILabel!
    @IBOutlet weak var todayTempMinLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourForecastCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var temperature: UILabel!
    var weatherObject: WeatherObject?
    var dailyWeather = [SingleDayData]()
    var cityNameString: String = ""
    var searchResult : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background")
        DataServices.loadWeather { weather in
            self.weatherObject  = weather
            let latitude = self.weatherObject?.lat ?? 0
            let longtitude = self.weatherObject?.long ?? 0
            self.reverseGeocoding(latitude: latitude, longitude: longtitude)
            self.dailyWeather = weather.singleDayDataPack
            self.updateCurrentWeather()
            self.dailyWeather.remove(at: 0)
            self.hourForecastCollectionView.reloadData()
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            else if (placemarks?.count ?? 0) > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                let city = pm.locality ?? ""
                self.location.text = city
                print("\n\(city)")
                if (pm.areasOfInterest?.count ?? 0) > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                } else {
                }
            }
        })
    }
    
    func updateCurrentWeather() {
        summary.text = weatherObject?.summary
        
        let currentTemp_c = weatherObject?.temp_c ?? 0
        temperature.text = "\(currentTemp_c)" + "°"
        
        let todayWeatherData = weatherObject?.singleDayDataPack[0]
        todayLabel.text = todayWeatherData?.time.unixToDateString(dateFormatterDesired: "EEEE")
        todayTempMaxLabel.text = todayWeatherData?.todayTempMax.todayTempMaxString
        todayTempMinLabel.text = todayWeatherData?.todayTempMin.todayTempMinString
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfItems = weatherObject?.singleHourDataPack.count ?? 0
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as? HourlyForecastCell else { fatalError() }
        
        let currentTime = indexPath.row == 0
        cell.time.text = currentTime ? "Now" : weatherObject?.singleHourDataPack[indexPath.row].time.unixToDateString(dateFormatterDesired: "HH")
        
        if let humidity = weatherObject?.singleHourDataPack[indexPath.row].humidity {
            cell.humidityLabel.text = "\(humidity)" + "%"
        }
        
        let iconString = weatherObject?.singleHourDataPack[indexPath.row].iconString ?? "default"
        cell.icon.image = UIImage(named: iconString)
        
        let temp_c = weatherObject?.singleHourDataPack[indexPath.row].temp_c ?? 0
        cell.temperature.text = "\(temp_c)" + "°"
        
        return cell
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dailyWeather.count == 0 ? 0 : dailyWeather.count + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 7  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! TodaySummaryCell
            let todaySummary = weatherObject?.todaySummary ?? ""
            cell.todaySummaryTextView.text = "Today: " + todaySummary
            return cell
        } else if indexPath.row > 7 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "otherinfocell", for: indexPath) as! OtherInfoCell
            
            let titles = [ "SUNRISE", "SUNSET", "CHANCE OF RAIN", "HUMIDITY", "WIND", "UV INDEX"]
            
            let todayWeatherData = weatherObject?.singleDayDataPack[0]
            var values = [todayWeatherData?.sunriseTime.sunriseString,
                          todayWeatherData?.sunsetTime.sunsetString,
                          todayWeatherData?.chanceOfRain.chainceOfRainString,
                          todayWeatherData?.humidity.humidityString,
                          todayWeatherData?.windSpeed.windSpeedString,
                          todayWeatherData?.uvIndex.uvIndexString]
            
            let index = (indexPath.row - 8) * 2
            otherCell.title1.text = titles[index]
            otherCell.title2.text = titles[index + 1]
            
            otherCell.value1.text = values[index]
            otherCell.value2.text = values[index + 1]
            
            
            return otherCell
            } else if indexPath.row < 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecastCell", for: indexPath) as! DailyForecastCell
            
                let dateString = dailyWeather[indexPath.row].time.unixToDateString(dateFormatterDesired: "EEEE")
                cell.dayLabel.text = dateString
            
                let iconString = dailyWeather[indexPath.row].iconString
                cell.weatherImageView.image = UIImage(named: iconString)
            
                let highestTemp_c = dailyWeather[indexPath.row].maxTemp_c
                cell.highestTempLabel.text = "\(highestTemp_c)"
            
                let lowestTemp_c = dailyWeather[indexPath.row].minTemp_c
                cell.lowestTempLabel.text = "\(lowestTemp_c)"
                return cell
            }
          return UITableViewCell()
        }
}
