//
//  Forcast.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/10/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil {
            _date = "unable to get date"
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = "unable to determine"
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = "unable to determine"
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = "unable to determine"
        }
        return _lowTemp
    }
    
    func getDayOfWeek(dayInt: Int) -> String? {
        switch dayInt {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Monday"
        }
    }

    init(weatherDictionary: Dictionary<String, AnyObject>) {
//        print("init with \(weatherDictionary)")
        if let temp = weatherDictionary["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                let minFarenheightTemp = 1.8 * (min - 273) + 32;
                self._lowTemp = "\(Int(minFarenheightTemp))"
            }
            if let max = temp["max"] as? Double {
                let maxFarenheightTemp = 1.8 * (max - 273) + 32;
                self._highTemp = "\(Int(maxFarenheightTemp))"
            }
        }
        
        if let weather = weatherDictionary["weather"] as? [Dictionary<String, AnyObject>] {
            if let type = weather[0]["main"] as? String {
                self._weatherType = type
            }
        }
        
        if let date = weatherDictionary["dt"] as? Double {
            let convertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            let weekday = Calendar.current.component(.weekday, from: convertedDate)
            self._date = getDayOfWeek(dayInt: weekday)
        }
        
    }
    
}


