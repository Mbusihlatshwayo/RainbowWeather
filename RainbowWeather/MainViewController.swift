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
    var shouldLoadWeather = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainWeatherLabel.adjustsFontSizeToFitWidth = true
        MainWeatherLabel.minimumScaleFactor = 0.2
        
        initLocationManager()
        
        tableView.delegate = self
        tableView.dataSource = self

        weatherObject = Weather()
        
        NotificationCenter.default.addObserver(self, selector:#selector(MainViewController.reloadWeather), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    func reloadWeather() {
        shouldLoadWeather = true
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted || status == .notDetermined {
            askForLocationServices()
        }
        
    }
    
    func askForLocationServices() {
        let alertController = UIAlertController(title: "Sorry", message: "Please enable location services for weather data.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // want coordinates to be very accurate
        locationManager.requestWhenInUseAuthorization() // only want location when looking for weather
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        shouldLoadWeather = true
        
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
        
        var forecast = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=615615de6ee7edd99b2c5e25110fc424"
        let forecastURL = URL(string: forecast)
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if shouldLoadWeather {
            forecastArray.removeAll() // clear array before populating with more weather data
            currentLocation = manager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            self.downloadForecast {
                self.weatherObject.downloadWeather {
                    self.updateUIWithWeather()
                }
            }
        }
        shouldLoadWeather = false
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    // update the labels with the data downloaded
    func updateUIWithWeather() {
        MainWeatherLabel.text = weatherObject.weatherType
        MainDateLabel.text = "Today \(weatherObject.date)"
        MainTempLabel.text = "\(weatherObject.currentTemp)°"
        MainLocLabel.text = weatherObject.cityName
        MainWeatherImage.image = UIImage(named: weatherObject.weatherType)
        
    }

}

