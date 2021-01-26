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
    var weatherRequestMaxRetry: BehaviorSubject<Int> { get }
    func currentWeather(city: String, maxRetryTimes: Int) -> Observable<Weather>
    func currentWeather(at lat: Double, lon: Double, maxRetryTimes: Int) -> Observable<Weather>
}

final class WeatherApi: WeatherApiType {
    
    func currentWeather(city: String,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.onNext(maxRetryTimes)
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
            .do(onNext: { [unowned self] _ in
                guard self.reachability.status.value == .online else {
                    throw ApplicationError(errorType: .noConnection,
                                           errorInfo: ("Looking for internet connection...",
                                                       "Internet connection failure"))
                }
            })
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
                                                           ("units", "metric")])
        let headers = RequestHeaderAdapter()
        let requestBuilder = RequestBuilder(baseUrl: baseURL,
                                            pathComponent: "weather",
                                            adapters: [headers, params],
                                            method: .get)
        
        return api
            .request(with: requestBuilder.request, retryHandler: retryHandler)
            .do(onNext: { [unowned self] _ in
                guard self.reachability.status.value == .online else {
                    throw ApplicationError(errorType: .noConnection,
                                           errorInfo: ("Looking for internet connection...",
                                                       "Internet connection failure"))
                }
            })
    }
    
    var weatherRequestMaxRetry: BehaviorSubject<Int> = .init(value: 0)
    // TODO: - move to weather api, it belongs to business logic
    // inject request with retry handler
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
            if count >= (try! self.weatherRequestMaxRetry.value()) - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                return self.reachability
                    .status
                    .map { (status: ReachabilityStatus) -> Bool in
                        return status == .online
                    }
                    .distinctUntilChanged()
                    .do(onNext: { isOnline in
                        guard isOnline == false else { return }
                        self.requestRetryMessage.accept("Waiting for internet connection...")
                    })
                    .filter { $0 == true }
                    .map { _ in 1 }
            }
            let symbol = self.attemptCounterSymbol(count + 1, symbol: "🟥")
            self.requestRetryMessage.accept("\(symbol) Retrying attempt \(count + 1) \(symbol)")
            return Observable<Int>
                .timer(RxTimeInterval.milliseconds(2000), scheduler: MainScheduler.instance)
                .take(1)
        }
    }
    
    private func attemptCounterSymbol(_ currentAttempt: Int, symbol: String) -> String {
        return [String](repeating: symbol, count: currentAttempt).joined()
    }
    
    /// Internal
    private let apiKey = "66687e09dee0508032ac82d5785ee2ad"
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let api: BaseNetworkClient
    private let reachability: ReachabilityType
}
