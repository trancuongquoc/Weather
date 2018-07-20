//
//  ViewController.swift
//  Weather
//
//  Created by quoccuong on 7/9/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourForecastCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var temperature: UILabel!
    var weatherObject: WeatherObject?
    var dailyWeather = [SingleDayData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background")
        
        DataServices.loadWeather { weather in
            self.weatherObject  = weather
            self.dailyWeather = weather.singleDayDataPack
            self.dailyWeather.remove(at: 0)
            self.updateCurrentWeather()
            self.hourForecastCollectionView.reloadData()
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCurrentWeather() {
        location.text = "Hanoi"
        summary.text = weatherObject?.summary
        
        let currentTemp_c = weatherObject?.temp_c ?? 0
        temperature.text = "\(currentTemp_c)" + "°"
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
        let otherCell = tableView.dequeueReusableCell(withIdentifier: "otherinfocell", for: indexPath) as! OtherInfoCell
        switch indexPath.row {
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! TodaySummaryCell
            let todaySummary = weatherObject?.todaySummary ?? ""
            cell.todaySummaryTextView.text = "Today: " + todaySummary
            return cell
        case 8:
            otherCell.title1.text = "SUNRISE"
            let sunriseTimeString = weatherObject?.singleDayDataPack[0].sunriseTime.unixToDateString(dateFormatterDesired: "HH:MM")
            otherCell.value1.text = sunriseTimeString
            
            otherCell.title2.text = "SUNSET"
            let sunsetTimeString = weatherObject?.singleDayDataPack[0].sunsetTime.unixToDateString(dateFormatterDesired: "HH:MM")
            otherCell.value2.text = sunsetTimeString
            return otherCell
        case 9:
            let chanceOfRain = weatherObject?.singleDayDataPack[0].chanceOfRain.correctFormat() ?? 0
            otherCell.title1.text = "CHANCE OF RAIN"
            otherCell.value1.text = "\(chanceOfRain)" + "%"
            
            let humidity = weatherObject?.singleDayDataPack[0].humidity.correctFormat() ?? 0
            otherCell.title2.text = "HUMIDITY"
            otherCell.value2.text = "\(humidity)" + "%"
            return otherCell
        case 10:
            let windSpeed = weatherObject?.singleDayDataPack[0].windSpeed ?? 0
            otherCell.title1.text = "WIND"
            otherCell.value1.text = "\(windSpeed)"
            
            let uvIndex = weatherObject?.singleDayDataPack[0].uvIndex ?? 0
            otherCell.title2.text = "UV INDEX"
            otherCell.value2.text = "\(uvIndex)"
            return otherCell
        default:
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
