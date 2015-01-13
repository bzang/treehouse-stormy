//
//  Current.swift
//  Stormy
//
//  Created by Bernie Zang on 1/4/15.
//  Copyright (c) 2015 Bernie Zang. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var currentTime: String?
    var temperature: Int
    var feelTemperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    var dewPoint: Double
    
    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        
        temperature = currentWeather["temperature"] as Int
        feelTemperature = currentWeather["apparentTemperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        dewPoint = currentWeather["dewPoint"] as Double

        currentTime = dateStringFromUnixTime(currentWeather["time"] as Int)
        icon = weatherIconFromString(currentWeather["icon"] as String)
        
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSec = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSec)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
            case "clear-day":
                imageName = "clear-day"
            case "clear-night":
                imageName = "clear-night"
            case "rain":
                imageName = "rain"
            case "snow":
                imageName = "snow"
            case "sleet":
                imageName = "sleet"
            case "wind":
                imageName = "wind"
            case "fog":
                imageName = "fog"
            case "cloudy":
                imageName = "cloudy"
            case "partly-cloudy-day":
                imageName = "partly-cloudy"
            case "partly-cloudy-night":
                imageName = "cloudy-night"
            default:
                imageName = "default"
        }
        
        let icon = UIImage(named: imageName)
        return icon!

    }
}