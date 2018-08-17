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
    var searchResult : String = "Hanoi"
    var lat: Double = 21.028511
    var long: Double = 105.804817
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationServices.forwardGeocoding(address: searchResult, callback: { location in
            self.lat = location.latitude
            self.long = location.longitude
            self.loadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        DataServices.loadWeather(lat: lat, long: long, complete: { weather in
            self.weatherObject  = weather
            self.weatherObject?.lat = self.lat
            self.weatherObject?.long = self.long
            LocationServices.reverseGeocoding(latitude: self.lat, longitude: self.long, callback: { city in
                self.location.text = city
            })
            self.updateUI()
            self.dailyWeather = weather.singleDayDataPack
            self.dailyWeather.remove(at: 0)
            self.hourForecastCollectionView.reloadData()
            self.tableView.reloadData()
        })
    }
    
    func updateUI() {
        summary.text = weatherObject?.summary
        
        let temp_cString = weatherObject?.temp_f.temp_cString ?? "0"
        temperature.text = temp_cString + "°"
        
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

extension ViewController: Delegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchTableViewController {
            destination.delegate = self
        }
    }
    
    func passSearchResult(with result: String) {
        searchResult = result
        print(searchResult)
    }
}
