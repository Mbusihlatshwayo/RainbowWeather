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
    
    func getDayOfWeel(dateParam: Date) -> String? {
        var dayString: String!
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: dateParam)
        print("get day function = \(weekDay)")
        if weekDay == 1 {
            dayString = "Monday"
        } else if weekDay == 2 {
            dayString = "Tuesday"
        } else if weekDay == 3 {
            dayString = "Wednesday"
        } else if weekDay == 4 {
            dayString = "Thursday"
        } else if weekDay == 5 {
            dayString = "Friday"
        } else if weekDay == 6 {
            dayString = "Saturday"
        } else if weekDay == 7 {
            dayString = "Sunday"
        }
        return dayString
    }

    init(weatherDictionary: Dictionary<String, AnyObject>) {
        
        if let temp = weatherDictionary["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                let minFarenheightTemp = 1.8 * (min - 273) + 32;
                self._lowTemp = "\(minFarenheightTemp)"
            }
            if let max = temp["max"] as? Double {
                let maxFarenheightTemp = 1.8 * (max - 273) + 32;
                self._highTemp = "\(maxFarenheightTemp)"
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
            self._date = getDayOfWeel(dateParam: convertedDate)
        }
        
    }
    
}


