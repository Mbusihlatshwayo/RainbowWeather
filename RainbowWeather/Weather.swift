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
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "No City Found"
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            print("in initializer")
            _date = "No date found"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = currentDate
        print("date initialization: \(currentDate)")
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = "Unable to determine"
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = currentDate
    }
    
    func downloadWeather(completed: @escaping DownloadComplete) {
        // download from api using alamofire
        let currentWeatherURL = URL(string: WEATHER_URL)
        
        // create request
        Alamofire.request(currentWeatherURL!).responseJSON { response in
            let result = response.result
            // since we fail to ever actually initialize the weather object via initialiazer 
            // do it explicitly here
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .long
//            dateFormatter.timeStyle = .none
//            
//            let currentDate = dateFormatter.string(from: Date())
//            self._date = currentDate
            // create the dictionary from the JSON response
            if let resultDict = result.value as? Dictionary<String, AnyObject> {
                if let name = resultDict["name"] as? String {
                    self._cityName = name.capitalized // City name is always capital
                    print(self._cityName)
                }
                
                if let JSONWeatherType = resultDict["weather"] as? [Dictionary<String,AnyObject>] {
                    if let type = JSONWeatherType[0]["main"] as? String {
                        self._weatherType = type.capitalized
                        print(self._weatherType)
                    }
                }
                
                if let main = resultDict["main"] as? Dictionary<String,AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let farenheightTemp = 1.8 * (currentTemperature - 273) + 32;
                        self._currentTemp = farenheightTemp
                        print(self._currentTemp)
                    }
                }
            }
            completed()
        }
        

    }

}
