//
//  WeatherApi.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import RxSwift
import RxCocoa
import Foundation


extension WeatherApi: ReachabilitySupporting { }

protocol WeatherApiType {
    func currentWeather(city: String, maxRetryTimes: Int) -> Observable<Weather>
    func currentWeather(at lat: Double, lon: Double, maxRetryTimes: Int) -> Observable<Weather>
}

final class WeatherApi: WeatherApiType {
    
    init(baseApi: BaseNetworkClient) {
        self.api = baseApi
    }
    
    func currentWeather(city: String,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.onNext(maxRetryTimes)
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", apiKey),
                                                           ("q", city),
                                                           ("units", "metric"),
                                                           ("lang", "ru")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api.request(with: requestBuilder.request,
                           retryHandler: retryHandler)
    }
    
    func currentWeather(at lat: Double,
                        lon: Double,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.onNext(maxRetryTimes)
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", apiKey),
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
                           retryHandler: retryHandler)
    }
    
    /// Internal
    private let apiKey = "66687e09dee0508032ac82d5785ee2ad"
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let api: BaseNetworkClient
   
    var weatherRequestMaxRetry: BehaviorSubject<Int> = .init(value: 0)
    // TODO: - move to weather api, it belongs to business logic
    // inject request with retry handler
    let requestRetryMessage = BehaviorRelay<String>(value: "")

    private lazy var retryHandler: RetryHandler = { [weak self] err in
        guard let self = self else { return Observable.just(0) }
        return err.enumerated().flatMap { count, error -> Observable<Int> in
            if count >= (try! self.weatherRequestMaxRetry.value()) - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                return self.reachability
                    .status
                    .map { (status: Reachability.Status) -> Bool in
                        return status == .online
                    }
                    .distinctUntilChanged()
                    .filter { $0 == true }
                    .map { _ in 1 }
            }
            self.requestRetryMessage.accept("🟥🟥🟥 Retry attempt: \(count + 1)")
            return Observable<Int>
                .timer(RxTimeInterval.milliseconds(2000), scheduler: MainScheduler.instance)
                .take(1)
        }
    }
}
