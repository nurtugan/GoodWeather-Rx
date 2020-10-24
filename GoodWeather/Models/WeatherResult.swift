//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by Nurtugan Nuraly on 10/15/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

extension WeatherResult {
    static var empty: WeatherResult {
        WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
