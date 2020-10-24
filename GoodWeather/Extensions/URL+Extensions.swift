//
//  URL+Extensions.swift
//  GoodWeather
//
//  Created by Nurtugan Nuraly on 10/24/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=67932b4ee3100af07b4186a7e60f0e3a")
    }
}
