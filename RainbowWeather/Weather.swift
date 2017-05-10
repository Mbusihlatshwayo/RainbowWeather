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
    var _weatherType: String! // sunny cloudy
    var _currentTemp: Double!
    
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
        self._date = "Today: \(currentDate)"
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
    
    func downloadWeather(completed: DownloadComplete) {
        // download from api using alamofire
        let currentWeatherURL = URL(string: WEATHER_URL)
        
        // create request
        Alamofire.request(currentWeatherURL!).responseJSON { response in
            let result = response.result
            print("ResultJSON\(response)")
        }
        completed()

    }

}
