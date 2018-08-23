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
import GooglePlaces

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
    
    var searchResult : String = "Hanoi" {
        didSet {
            retrieveWeatherDataFromSearchResult()
        }
    }
    
    var resultsViewController: GMSAutocompleteViewController?
    var searchController: UISearchController?
    
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background")
        
        resultsViewController = GMSAutocompleteViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
        
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentPlace()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCurrentPlace() {
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        retrieveData(lat: lat!, long: long!)
    }
    
    func retrieveWeatherDataFromSearchResult() {
        LocationServices.forwardGeocoding(address: searchResult, callback: { location in
            let lat  = location.latitude
            let long = location.longitude
            self.retrieveData(lat: lat, long: long)
        })
    }
    
    func retrieveData(lat: Double, long: Double) {
        DataServices.loadWeather(lat: lat, long: long, complete: { weather in
            self.weatherObject  = weather
            self.weatherObject?.lat = lat
            self.weatherObject?.long = long
            LocationServices.reverseGeocoding(latitude: lat, longitude: long, callback: { city in
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
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        present(autocompleteController, animated: true, completion: nil)
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

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchResult = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


