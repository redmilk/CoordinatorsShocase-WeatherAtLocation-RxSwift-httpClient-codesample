//
//  Weather.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 31.10.2020.
//

import CoreLocation

// MARK: - Weather
struct Weather: Codable {
    
    static var e: Error? = nil
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
    }
    private let coord: Coord
    
    let weather: [WeatherElement]?
    let base: String?
    let main: MainWeatherInfo
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct MainWeatherInfo: Codable {
    let feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let grndLevel: Int?
    let seaLevel: Int?
    
    private let temp: Double
    var tempRounded: Int {
        return Int(ceil(temp))
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
