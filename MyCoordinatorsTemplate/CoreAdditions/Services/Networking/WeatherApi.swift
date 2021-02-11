//
//  WeatherApi.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import RxSwift
import RxCocoa
import Foundation


extension WeatherApi: ReachabilityCheckable { }

protocol WeatherApiProtocol {
    var requestRetryMessage: BehaviorRelay<String> { get }
    var weatherRequestMaxRetry: BehaviorRelay<Int> { get }
    func currentWeather(city: String, maxRetryTimes: Int) -> Observable<Weather>
    func currentWeather(at lat: Double, lon: Double, maxRetryTimes: Int) -> Observable<Weather>
}

final class WeatherApi: WeatherApiProtocol {
    
    func currentWeather(city: String,
                        maxRetryTimes: Int = 5
    ) -> Observable<Weather> {
        weatherRequestMaxRetry.accept(maxRetryTimes)
        let params = RequestParametersAdapter(withBody: false,
                                              parameters: [("appid", Constants.weatherApiKey),
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
                                              parameters: [("appid", Constants.weatherApiKey),
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
         reachability: ReachabilityProtocol
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
                .timer(RxTimeInterval.seconds(2 * max(1, count)), scheduler: MainScheduler.instance)
                .take(1)
        }
    }
        
    private func retryAttemptCounterSymbol(_ currentAttempt: Int, symbol: String) -> String {
        return [String](repeating: symbol, count: currentAttempt).joined()
    }
    
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let api: BaseNetworkClient
    private let reachability: ReachabilityProtocol
}
