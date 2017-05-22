//
//  ViewController.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/9/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    // outlets
    @IBOutlet weak var MainDateLabel: UILabel!
    @IBOutlet weak var MainTempLabel: UILabel!
    @IBOutlet weak var MainLocLabel: UILabel!
    @IBOutlet weak var MainWeatherImage: UIImageView!
    @IBOutlet weak var MainWeatherLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var weatherObject: Weather!
    var forecastObject: Forecast!
    var forecastArray = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // want coordinates to be very accurate
        locationManager.requestWhenInUseAuthorization() // only want location when looking for weather
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        weatherObject = Weather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell {
            let forecast = forecastArray[indexPath.row+1]
            print(forecast._date)
            cell.configCell(forecast: forecast)
            return cell
        } else {
            return WeatherTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // download weather forcast and store in array
    func downloadForecast(completed: @escaping DownloadComplete) {
        print("called download forecast: \(FORECAST_URL)")
        let forecastURL = URL(string: FORECAST_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            let result = response.result
            if let resultDict = result.value as? Dictionary<String, AnyObject> {
                if let weatherList = resultDict["list"] as? [Dictionary<String, AnyObject>] {
                    for object in weatherList {
                        let forecast = Forecast(weatherDictionary: object)
                        self.forecastArray.append(forecast)
                    }
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print("location : \(Location.sharedInstance.latitude!) \(Location.sharedInstance.longitude!)")
            weatherObject.downloadWeather {
                self.downloadForecast {
                    self.updateUIWithWeather()
                }
                
            }

        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    // update the labels with the data downloaded
    func updateUIWithWeather() {
        MainWeatherLabel.text = weatherObject._weatherType
        MainDateLabel.text = "Today \(weatherObject.date)"
        MainTempLabel.text = "\(weatherObject.currentTemp)°"
        MainLocLabel.text = weatherObject.cityName
        MainWeatherImage.image = UIImage(named: weatherObject.weatherType)
        
    }

}

