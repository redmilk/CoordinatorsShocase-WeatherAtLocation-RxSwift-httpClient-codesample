//
//  FormattingService.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 05.11.2020.
//

import Foundation

struct MainSceneStateFormatter: StateContentFormattable {
    func format(state: MainSceneState) -> MainSceneState {
        let formatted = state.copy()
        let humidity = try? state.humidity.value()
        let temperature = try? state.temperature.value()
        if let h = humidity, let t = temperature {
            formatted.humidity.onNext("Humidity: " + h + "%")
            formatted.temperature.onNext("Temp: " + t + "℃")
        }
        return formatted
    }
}
