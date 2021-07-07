//
//  weatherData.swift
//  MyWeatherApp
//
//  Created by Doha Tubaileh on 29/6/2021.
//

import Foundation

struct WeatherData : Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
    
}
