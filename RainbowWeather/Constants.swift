//
//  constants.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/9/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let COUNT = "&cnt=10"
let MY_API_KEY = "615615de6ee7edd99b2c5e25110fc424"
let WEATHER_URL = "\(BASE_URL)\(LATITUDE)-25\(LONGITUDE)134\(APP_ID)\(MY_API_KEY)"
let BASE_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?"
//let FORECAST_WEATHER_URL = "\(BASE_FORECAST_URL)\(LATITUDE)-25\(LONGITUDE)134\(COUNT)\(APP_ID)615615de6ee7edd99b2c5e25110fc424"
let FORECAST_WEATHER_URL = "\(BASE_FORECAST_URL)\(LATITUDE)-25\(LONGITUDE)134\(COUNT)\(APP_ID)\(MY_API_KEY)"
typealias DownloadComplete = () -> ();
