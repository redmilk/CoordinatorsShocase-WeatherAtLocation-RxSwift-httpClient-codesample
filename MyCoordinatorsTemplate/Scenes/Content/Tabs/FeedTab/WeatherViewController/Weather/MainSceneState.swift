//
//  MainSceneState.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import CoreLocation
import RxCocoa
import RxSwift


// MARK: State
class MainSceneState {
 
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
        
    func copy() -> MainSceneState {
        let state = MainSceneState()
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
    
    static var initial: MainSceneState {
        let state = MainSceneState()
        state.searchText.onNext("Kiev")
        state.weatherIcon.onNext("Initial")
        state.temperature.onNext("24")
        state.humidity.onNext("65")
        return state
    }
}
