//
//  FormattingService.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 05.11.2020.
//

import Foundation

struct WeatherSceneStateFormatter: StateContentFormattable {
    func format(state: WeatherSceneState) -> WeatherSceneState {
        let formatted = state.copy()
        let humidity = state.humidity.value
        let temperature = state.temperature.value
        formatted.humidity.accept("Humidity: " + humidity + "%")
        formatted.temperature.accept("Temp: " + temperature + "℃")
        return formatted
    }
}
