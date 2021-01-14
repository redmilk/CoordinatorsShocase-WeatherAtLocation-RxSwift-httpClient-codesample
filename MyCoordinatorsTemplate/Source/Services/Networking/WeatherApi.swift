//
//  WeatherApi.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import RxSwift
import Foundation

fileprivate let weatherRequestMaxRetry: Int = 5

struct WeatherApi {
    
    private let apiKey = BehaviorSubject<String>(value: "66687e09dee0508032ac82d5785ee2ad")
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let api: BaseNetworkClient
    
    init(requestable: BaseNetworkClient) {
        self.api = requestable
    }
    
    func currentWeather(city: String) -> Observable<Weather> {
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", (try? apiKey.value()) ?? ""),
                                                           ("q", city),
                                                           ("units", "metric"),
                                                           ("lang", "ru")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api.request(with: requestBuilder.request,
                           maxRetry: weatherRequestMaxRetry)
    }
    
    func currentWeather(at lat: Double, lon: Double) -> Observable<Weather> {
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", (try? apiKey.value()) ?? ""),
                                                           ("lat", "\(lat)"),
                                                           ("lon", "\(lon)"),
                                                           ("units", "metric"),
                                                           ("lang", "ru")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api.request(with: requestBuilder.request,
                           maxRetry: weatherRequestMaxRetry)
    }
}
