//
//  ViewController.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/9/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets
    @IBOutlet weak var MainDateLabel: UILabel!
    @IBOutlet weak var MainTempLabel: UILabel!
    @IBOutlet weak var MainLocLabel: UILabel!
    @IBOutlet weak var MainWeatherImage: UIImageView!
    @IBOutlet weak var MainWeatherLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var weatherObject: Weather!
    var forecastObject: Forecast!
    var forecastArray = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("Downloading from:\(WEATHER_URL)")
        weatherObject = Weather()
        weatherObject.downloadWeather {
            self.downloadForecast {
                self.updateUIWithWeather()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        let forecastURL = URL(string: FORECAST_WEATHER_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            let result = response.result
            if let resultDict = result.value as? Dictionary<String, AnyObject> {
                if let weatherList = resultDict["list"] as? [Dictionary<String, AnyObject>] {
                    for object in weatherList {
                        let forecast = Forecast(weatherDictionary: object)
                        self.forecastArray.append(forecast)
                    }
                }
            }
            completed()
        }
    }

    func updateUIWithWeather() {
        MainWeatherLabel.text = weatherObject._weatherType
        MainDateLabel.text = "Today \(weatherObject.date)"
        MainTempLabel.text = "\(weatherObject._currentTemp!)°"
        MainLocLabel.text = weatherObject.cityName
        MainWeatherImage.image = UIImage(named: weatherObject.weatherType)
        
    }

}

