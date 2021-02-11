//
//  MainSceneState.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import CoreLocation
import RxCocoa
import RxSwift

// MARK: - State formatting
extension WeatherSceneState: Formatting {
    var formatted: WeatherSceneState {
        return formatting.weatherStateFormatter.format(state: self)
    }
}

// MARK: State
class WeatherSceneState {
 
    var searchText = BehaviorRelay<String>(value: "")
    var temperature = BehaviorRelay<String>(value: "")
    var humidity = BehaviorRelay<String>(value: "")
    var weatherIcon = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var location = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    var requestRetryText = BehaviorRelay<String>(value: "")
    var locationPermission = BehaviorRelay<Bool?>(value: nil)
   
    func updateWeather(_ weather: Weather) {
        searchText.accept(weather.name)
        temperature.accept(weather.main.tempRounded.description)
        humidity.accept(weather.main.humidity.description)
        weatherIcon.accept(weather.weather?.first?.icon ?? "")
    }
        
    func copy() -> WeatherSceneState {
        let state = WeatherSceneState()
        state.searchText = self.searchText
        state.temperature = self.temperature
        state.humidity = self.humidity
        state.weatherIcon = self.weatherIcon
        state.isLoading = self.isLoading
        state.location = self.location
        state.requestRetryText = self.requestRetryText
        return state
    }
    
    static var initial: WeatherSceneState {
        let state = WeatherSceneState()
        state.searchText.accept("Kievkdsf")
        state.weatherIcon.accept("Initial")
        state.temperature.accept("2")
        state.humidity.accept("73")
        return state.formatted
    }
}
