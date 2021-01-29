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
    var requestRetryMessage: BehaviorRelay<String> { get }
    var weatherRequestMaxRetry: BehaviorRelay<Int> { get }
    func currentWeather(city: String, maxRetryTimes: Int) -> Observable<Weather>
    func currentWeather(at lat: Double, lon: Double, maxRetryTimes: Int) -> Observable<Weather>
}

final class WeatherApi: WeatherApiType {
    
    func currentWeather(city: String,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.accept(maxRetryTimes)
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", apiKey),
                                                           ("q", city),
                                                           ("units", "metric")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api
            .request(with: requestBuilder.request, retryHandler: retryHandler)
    }
    
    func currentWeather(at lat: Double,
                        lon: Double,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.accept(maxRetryTimes)
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", apiKey),
                                                           ("lat", "\(lat)"),
                                                           ("lon", "\(lon)"),
                                                           ("units", "metric")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api
            .request(with: requestBuilder.request, retryHandler: retryHandler)
    }
    
    let weatherRequestMaxRetry = BehaviorRelay<Int>(value: 0)
    let requestRetryMessage = BehaviorRelay<String>(value: "")

    init(baseApi: BaseNetworkClient,
         reachability: ReachabilityType
    ) {
        self.api = baseApi
        self.reachability = reachability
    }
    
    private lazy var retryHandler: RetryHandler = { [weak self] err in
        guard let self = self else { return Observable.just(0) }
        return err.enumerated().flatMap { count, error -> Observable<Int> in
            if count >= self.weatherRequestMaxRetry.value {
                self.requestRetryMessage.accept("")
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                return self.reachability
                    .status
                    .map { (status: ReachabilityStatus) -> Bool in
                        return status == .online
                    }
                    .distinctUntilChanged()
                    .do(onNext: { isOnline in
                        isOnline ? self.requestRetryMessage.accept("") :
                            self.requestRetryMessage.accept("🟩 Waiting for internet connection... 🟩")
                    })
                    .filter { $0 == true }
                    .map { _ in 1 }
            }
            let symbol = self.retryAttemptCounterSymbol(count + 1, symbol: "🟥")
            let errorTitle: String = Utils.fetchErrorInfoTitle(error)
            self.requestRetryMessage.accept("\(symbol) \(errorTitle). Retrying \(count + 1) \(symbol)")
            return Observable<Int>
                .timer(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
                .take(1)
        }
    }
        
    private func retryAttemptCounterSymbol(_ currentAttempt: Int, symbol: String) -> String {
        return [String](repeating: symbol, count: currentAttempt).joined()
    }
    
    private let apiKey = "66687e09dee0508032ac82d5785ee2ad"
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let api: BaseNetworkClient
    private let reachability: ReachabilityType
}
