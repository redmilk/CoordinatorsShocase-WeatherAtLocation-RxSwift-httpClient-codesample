//
//  MainSceneReducer.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import RxSwift
import RxCocoa
import Foundation
import CoreLocation


// MARK: Reducer
extension WeatherSceneViewModel: StateStoreSupporting,
                                 LocationSupporting,
                                 ReachabilitySupporting,
                                 NetworkSupporting,
                                 WeatherApiSupporting { }

class WeatherSceneViewModel {
    
    // TODO: - user drivers
    // TODO: - refactor to actions
    
    enum Action {
        case getWeatherBy(city: String)
        case currentLocationWeather
        case cancelRequest
        case none
    }
    
    private var currentLocationWeather: Observable<Weather> {
        return self.locationService.currentLocation
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .flatMap { self.weatherApi.currentWeather(at: $0.0, lon: $0.1) }
    }
    
    private lazy var actualState: BehaviorSubject<WeatherSceneState> = {
        return BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial)
    }()
    
    private var bag = DisposeBag()
    
    /// Input
    var action = PublishSubject<Action>()
    
    init() {
        bind()
    }
    
    private func bind() {
        bag = DisposeBag()
        /// Output to state storage
        actualState
            .asObservable()
            .bind(to: store.mainSceneState)
            .disposed(by: bag)
        
        /// Dispatching actions
        action
            .asObservable()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                
                let newState = (try? self.actualState.value()) ?? WeatherSceneState.initial
                newState.requestRetryText.onNext(self.weatherApi.requestRetryMessage.value)
                
                switch action {
                
                /// city search weather
                case .getWeatherBy(let city):
                    if self.reachability.status.value != .online {
                        newState.errorAlertContent.onNext(self.handleError(ApplicationErrors.Network.noConnection))
                        newState.errorAlertContent.onNext(nil)
                    }
                    self.loadWeather(self.weatherApi.currentWeather(city: city, maxRetryTimes: 5), state: newState)
                    
                /// current location weather
                case .currentLocationWeather:
                    self.locationService.requestPermission()
                    if self.reachability.status.value != .online {
                        newState.errorAlertContent.onNext(self.handleError(ApplicationErrors.Network.noConnection))
                        newState.errorAlertContent.onNext(nil)
                    }
                    guard self.locationService.locationServicesEnabled() else {
                        newState.errorAlertContent.onNext(self.handleError(ApplicationErrors.Location.noPermission))
                        newState.errorAlertContent.onNext(nil)
                        return
                    }
                    self.loadWeather(self.currentLocationWeather, state: newState)
                    
                    /// cancel currentrunning request
                case .cancelRequest:
                    self.cancelRequest(Observable.just(()), state: newState)
                case .none:
                    break
                }
            })
            .disposed(by: bag)
        
        /// for debug
        weatherApi.requestRetryMessage
            .filter { !$0.isEmpty }
            .subscribe(onNext: { msg in
                let state = try? self.actualState.value()
                state?.requestRetryText.onNext(msg)
            })
            .disposed(by: bag)
    }
    
    /// Internal
    private func loadWeather(_ weather: Observable<Weather>, state: WeatherSceneState) {
        state.isLoading.onNext(true)
        return weather
            .take(1)
            .map { (weather) -> WeatherSceneState in
                state.isLoading.onNext(false)
                state.updateWeather(weather)
                return state.formatted
            }
            .catch { [weak self] error in
                guard let self = self else { return Observable.just(state) }
                state.isLoading.onNext(false)
                state.errorAlertContent.onNext(self.handleError(error))
                state.errorAlertContent.onNext(nil)
                //let cachedWeather: Weather = Weather()
                //state.updateWeather(<#T##weather: Weather##Weather#>)
                return Observable.just(state)
            }
            .bind(to: self.actualState)
            .disposed(by: self.bag)
    }
    
    private func cancelRequest(_ cancel: Observable<()>, state: WeatherSceneState) {
        bind()
        
        return cancel
            .map { [weak self] in
                state.isLoading.onNext(false)
                state.errorAlertContent.onNext(nil)
                state.requestRetryText.onNext("")
                
                self?.weatherApi.requestRetryMessage.accept("")
                self?.weatherApi.weatherRequestMaxRetry.onNext(0)
                return state
            }
            .bind(to: self.actualState)
            .disposed(by: bag)
    }
}


// MARK: Error handling
extension WeatherSceneViewModel: ErrorHandling {
    func handleError(_ error: Error) -> (String, String)? {
        switch error {
        case let request as ApplicationErrors.ApiClient:
            switch request {
            case .notFound:
                return ("City not found", "😰")
            case .serverError:
                return ("Something went wrong", "Server error")
            case .invalidToken:
                return ("Token is invalid", "Required authentication")
            case .invalidResponse:
                return ("Request failure", "Ivalid response")
            case .deserializationFailed:
                return ("Deserialization failure", "Decodable fail")
            }
        case let location as ApplicationErrors.Location:
            switch location {
            case .noPermission:
                return ("Please provide access to location services in Settings app", "No location access")
            }
        case let network as ApplicationErrors.Network:
            switch network {
            case .noConnection:
                return ("Looking for internet connection...", "Internet connection failure")
            }
        default: break
        }
        return nil
    }
}
