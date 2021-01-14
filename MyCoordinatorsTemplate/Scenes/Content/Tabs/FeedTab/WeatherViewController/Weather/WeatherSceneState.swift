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
 
    var searchText = BehaviorSubject<String>(value: "")
    var temperature = BehaviorSubject<String>(value: "")
    var humidity = BehaviorSubject<String>(value: "")
    var weatherIcon = BehaviorSubject<String>(value: "")
    var isLoading = PublishSubject<Bool>()
    var location = PublishSubject<CLLocationCoordinate2D?>()
    var requestRetryText = PublishSubject<String>()
    var locationPermission = PublishSubject<Bool>()
    var errorAlertContent = BehaviorSubject<(String, String)?>(value: nil)
   
    func updateWeather(_ weather: Weather) {
        searchText.onNext(weather.name)
        temperature.onNext(weather.main.temp.description)
        humidity.onNext(weather.main.humidity.description)
        weatherIcon.onNext(weather.weather?.first?.icon ?? "")
    }
        
    func copy() -> WeatherSceneState {
        let state = WeatherSceneState()
        state.searchText = self.searchText
        state.temperature = self.temperature
        state.humidity = self.humidity
        state.weatherIcon = self.weatherIcon
        state.isLoading = self.isLoading
        state.location = self.location
        state.errorAlertContent = self.errorAlertContent
        state.requestRetryText = self.requestRetryText
        state.errorAlertContent = self.errorAlertContent
        return state
    }
    
    static var initial: WeatherSceneState {
        let state = WeatherSceneState()
        state.searchText.onNext("Kiev")
        state.weatherIcon.onNext("Initial")
        state.temperature.onNext("2")
        state.humidity.onNext("73")
        return state.formatted
    }
}
