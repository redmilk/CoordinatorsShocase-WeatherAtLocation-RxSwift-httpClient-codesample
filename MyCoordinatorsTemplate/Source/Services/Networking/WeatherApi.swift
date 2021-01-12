//
//  WeatherApi.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import RxSwift

fileprivate let weatherRequestMaxRetry: Int = 5

struct WeatherApi {
    
    private let api: ApiRequestable
    
    init(requestable: ApiRequestable) {
        self.api = requestable
    }
    
    func currentWeather(city: String) -> Observable<Weather> {
        return api
            .request(method: "GET",
                     pathComponent: "weather",
                     params: [("q", city)],
                     maxRetry: weatherRequestMaxRetry
            )
            .map { $0 }
    }
    
    func currentWeather(at lat: Double, lon: Double) -> Observable<Weather> {
        return api
            .request(method: "GET",
                     pathComponent: "weather",
                     params: [("lat", "\(lat)"), ("lon", "\(lon)")],
                     maxRetry: weatherRequestMaxRetry
            )
            .map { $0 }
    }
}
