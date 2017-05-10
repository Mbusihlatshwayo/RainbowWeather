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
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell {
            let forecast = forecastArray[indexPath.row]
            cell.configCell(forecast: forecast)
            return cell
        } else {
            return WeatherTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        print("called download forecast")
        let forecastURL = URL(string: FORECAST_WEATHER_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            let result = response.result
            if let resultDict = result.value as? Dictionary<String, AnyObject> {
                print("resultDict\(resultDict)")
                if let weatherList = resultDict["list"] as? [Dictionary<String, AnyObject>] {
                    print("and again")
                    for object in weatherList {
                        print(object)
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

