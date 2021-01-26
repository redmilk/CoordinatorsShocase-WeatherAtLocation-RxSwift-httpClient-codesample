//
//  WeatherService.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import RxSwift
import RxCocoa

protocol WeatherServiceType {
    func weather(by city: String) -> Observable<Weather>
    func weatherByCurrentLocation() -> Observable<Weather>
    func terminateRequest()
    var requestRetryMessage: BehaviorRelay<String> { get }
}

class WeatherService: WeatherServiceType {
    
    func weather(by city: String) -> Observable<Weather> {
        return weatherApi.currentWeather(city: city,
                                         maxRetryTimes: maxRetryTimes)
    }
    
    func weatherByCurrentLocation() -> Observable<Weather> {
        self.location.requestPermission()
        
        return self.location
            .locationServicesAuthorizationStatus
            .do(onNext: { status in
                switch status {
                case .denied, .restricted:
                    throw ApplicationError(errorType: .noLocationPermission,
                                           errorInfo: ("Please provide access to location services in Settings app",
                                                                                            "No location access"))
                case _: break
                }
            })
            .flatMap { [unowned self] _ -> Observable<Weather> in
                return self.locationWeather
            }
    }
    
    func terminateRequest() {
        weatherApi.requestRetryMessage.accept("")
        weatherApi.weatherRequestMaxRetry.onNext(0)
    }
    
    var requestRetryMessage: BehaviorRelay<String> {
        return weatherApi.requestRetryMessage
    }
    
    init(weatherApi: WeatherApiType,
         location: LocationServiceType
    ) {
        self.weatherApi = weatherApi
        self.location = location
    }
    
    private var locationWeather: Observable<Weather> {
        return self.location.currentLocation
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .flatMap { [unowned self] in
                self.weatherApi.currentWeather(at: $0.0, lon: $0.1,
                                               maxRetryTimes: self.maxRetryTimes)
            }
    }
    
    private let weatherApi: WeatherApiType
    private let location: LocationServiceType
    private let maxRetryTimes: Int = 5
}
