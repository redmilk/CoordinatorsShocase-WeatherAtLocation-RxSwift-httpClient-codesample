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

// TODO: - use drivers
// TODO: - refactor to actions

/// internal types
extension WeatherSceneViewModel {
    enum Action {
        case getWeatherBy(city: String)
        case currentLocationWeather
        case cancelRequest
        case none
    }
    
    struct Input {
        var action: PublishSubject<Action>
    }
    
    struct Output {
        var actualState: BehaviorSubject<WeatherSceneState>
    }
}


/// capabilities
/// Access to state store
extension WeatherSceneViewModel: StateStorageAccassible,
                                 LocationSupporting,
                                 ReachabilitySupporting, // TODO: - check for neccessary
                                 WeatherApiSupporting { }


/// implementation
class WeatherSceneViewModel {
    
    private let coordinator: WeatherCoordinator
    
    /// input from view
    public var input = Input(action: PublishSubject<Action>())
    
    init(coordinator: WeatherCoordinator) {
        self.coordinator = coordinator
        bind()
    }
        
    /// output to state storage
    private var output = Output(actualState: BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial))
    
    func bind() {
        bag = DisposeBag()
        let newState = (try? self.output.actualState.value()) ?? WeatherSceneState.initial
        
        /// Reducing actions
        input.action
            .asObservable()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                /// fetching current actual state
                let newState = (try? self.output.actualState.value()) ?? WeatherSceneState.initial
                newState.requestRetryText.onNext(self.weatherApi.requestRetryMessage.value)
                
                switch action {
                
                /// city search weather
                case .getWeatherBy(let city):
                    self.loadWeather(self.weatherApi.currentWeather(city: city, maxRetryTimes: 5), state: newState)
                    
                /// current location weather
                case .currentLocationWeather:
                    self.locationService.requestPermission()
                    self.locationService
                        .locationServicesAuthorizationStatus
                        .subscribe(onNext: { status in
                            switch status {
                            case .authorizedAlways, .authorizedWhenInUse:
                                self.loadWeather(self.currentLocationWeather, state: newState)
                            case .restricted, .denied:
                                self.handleError(ApplicationErrors.Location.noPermission)
                                //newState.errorAlertContent.onNext()
                                //newState.errorAlertContent.onNext(nil)
                            case _: break
                            }
                        })
                        .disposed(by: self.bag)
                    /// cancel current processing request
                
                case .cancelRequest:
                    self.cancelRequest(Observable.just(()), state: newState)
                    
                case .none:
                    break
                }
            })
            .disposed(by: bag)
        
        output.actualState
            .asObservable()
            .bind(to: store.mainSceneState)
            .disposed(by: bag)
        
        /// debug
        weatherApi.requestRetryMessage
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] msg in
                let state = try? self?.output.actualState.value()
                state?.requestRetryText.onNext(msg)
            })
            .disposed(by: bag)
    }
    
    private func loadWeather(_ weather: Observable<Weather>, state: WeatherSceneState) {
        if self.reachability.status.value != .online {
            self.handleError(ApplicationErrors.ApiClient.noConnection)
//            state.errorAlertContent.onNext()
//            state.errorAlertContent.onNext(nil)
        }
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
                self.handleError(error)
                //state.errorAlertContent.onNext(self.handleError(error))
                //state.errorAlertContent.onNext(nil)
                return Observable.just(state)
            }
            .bind(to: output.actualState)
            .disposed(by: bag)
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
            .bind(to: output.actualState)
            .disposed(by: bag)
    }
    
    private var currentLocationWeather: Observable<Weather> {
        return self.locationService.currentLocation
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .flatMap { [weak self] in
                self?.weatherApi.currentWeather(at: $0.0, lon: $0.1) ?? Observable.just(Weather())
            }
    }
    
    private var bag = DisposeBag()
}


// MARK: Error handling
extension WeatherSceneViewModel: ErrorHandling {
    
    @discardableResult
    func handleError(_ error: Error) -> (String, String)? {
        switch error {
        case let request as ApplicationErrors.ApiClient:
            switch request {
            case .notFound:
                coordinator.displayAlert(errorData: ("City not found", "😰"), bag: bag)
            case .serverError:
                coordinator.displayAlert(errorData: ("Something went wrong", "Server error"), bag: bag)
            case .unauthorized:
                coordinator.displayAlert(errorData: ("Token is invalid", "Required authentication"), bag: bag)
            case .invalidResponse:
                coordinator.displayAlert(errorData: ("Request failure", "Ivalid response"), bag: bag)
            case .deserializationFailed:
                coordinator.displayAlert(errorData: ("Deserialization failure", "Decodable fail"), bag: bag)
            case .noConnection:
                coordinator.displayAlert(errorData: ("Looking for internet connection...", "Internet connection failure"), bag: bag)
            case _: break
            }
        case let location as ApplicationErrors.Location:
            switch location {
            case .noPermission:
                coordinator.displayAlert(errorData: ("Please provide access to location services in Settings app", "No location access"), bag: bag)
            }
        default: break
        }
        return nil
    }
}
