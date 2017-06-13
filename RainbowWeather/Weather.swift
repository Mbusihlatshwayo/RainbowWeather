//
//  Weather.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/9/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String! // sunny, cloudy, overcast...
    var _currentTemp: Int!
    
//    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=615615de6ee7edd99b2c5e25110fc424"
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "No City Found"
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = "No date found"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = currentDate
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = "Unable to determine"
        }
        return _weatherType
    }
    
    var currentTemp: Int {
        if _currentTemp == nil {
            _currentTemp = 0
        }
        return _currentTemp
    }
    
    func downloadWeather(completed: @escaping DownloadComplete) {
        // download from api using alamofire
        var weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=615615de6ee7edd99b2c5e25110fc424"
        let currentWeatherURL = URL(string: weatherURL)
        
        // create request
        Alamofire.request(currentWeatherURL!).responseJSON { response in
            let result = response.result
            if let resultDict = result.value as? Dictionary<String, AnyObject> {
                if let name = resultDict["name"] as? String {
                    self._cityName = name.capitalized // City name is always capital
                }
                
                if let JSONWeatherType = resultDict["weather"] as? [Dictionary<String,AnyObject>] {
                    if let type = JSONWeatherType[0]["main"] as? String {
                        self._weatherType = type.capitalized
                    }
                }
                
                if let main = resultDict["main"] as? Dictionary<String,AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let farenheightTemp = Int(1.8 * (currentTemperature - 273) + 32)
                        self._currentTemp = farenheightTemp
                    }
                }
            }
            completed()
        }
        

    }

}
