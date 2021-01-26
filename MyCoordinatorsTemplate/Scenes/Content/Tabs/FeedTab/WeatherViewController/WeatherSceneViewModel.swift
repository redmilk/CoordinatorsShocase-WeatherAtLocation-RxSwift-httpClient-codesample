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

//TODO: - show error message when is waiting for connection

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
extension WeatherSceneViewModel: StateStorageAccassible { }


/// implementation
class WeatherSceneViewModel {
    
    private let coordinator: WeatherCoordinator
    private let weatherService: WeatherServiceType
    
    /// input from view
    public var input = Input(action: PublishSubject<Action>())
    
    init(coordinator: WeatherCoordinator,
         weatherService: WeatherServiceType
    ) {
        self.coordinator = coordinator
        self.weatherService = weatherService
        bind()
    }
        
    /// output to state storage
    private var output = Output(actualState: BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial))
    
    private var currentState: WeatherSceneState {
        return (try? self.output.actualState.value()) ?? WeatherSceneState.initial
    }
    
    func bind() {
        /// Reducing actions
        input.action
            .asObservable()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                /// fetching current actual state
                let newState = self.currentState
                newState.requestRetryText.onNext(self.weatherService.requestRetryMessage.value)
                
                switch action {
                
                /// city search weather
                case .getWeatherBy(let city):
                    let weather = self.weatherService.weather(by: city)
                    self.reduce(weather, state: newState)
                    
                /// current location weather
                case .currentLocationWeather:
                    let weather = self.weatherService.weatherByCurrentLocation()
                    self.reduce(weather, state: newState)
                    
                case .cancelRequest:
                    self.terminate()
                    
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
        weatherService.requestRetryMessage
            .subscribe(onNext: { [unowned self] msg in
                let state = (try? self.output.actualState.value()) ?? .initial
                state.requestRetryText.onNext(msg)
            })
            .disposed(by: bag)
    }
    
    private func reduce(_ weather: Observable<Weather>, state: WeatherSceneState) {
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
                return Observable.just(state)
            }
            .bind(to: output.actualState)
            .disposed(by: bag)
    }
    
    private func terminate() {
        self.bag = DisposeBag()
        self.bind()
        self.weatherService.terminateRequest()
        let newState = currentState
        newState.isLoading.onNext(false)
        newState.errorAlertContent.onNext(nil)
        self.output.actualState.onNext(newState)
    }

    private var bag = DisposeBag()
}


// MARK: Error handling
extension WeatherSceneViewModel: ErrorHandling {
    
    @discardableResult
    func handleError(_ error: Error) -> (String, String)? {
        guard let error = error as? ApplicationError,
              let errorInfo = error.errorInfo else { return nil }
        coordinator.displayAlert(errorData: errorInfo, bag: bag)
        return errorInfo
        
        // TODO: - check all errors presence
//        switch error {
//        case let requestError as ApplicationErrors.ApiClient:
//            switch requestError {
//            case .notFound(let errorData):
//                coordinator.displayAlert(errorData: errorData, bag: bag)
//            case .serverError:
//                coordinator.displayAlert(errorData: ("Something went wrong", "Server error"), bag: bag)
//            case .unauthorized:
//                coordinator.displayAlert(errorData: ("Token is invalid", "Required authentication"), bag: bag)
//            case .invalidResponse:
//                coordinator.displayAlert(errorData: ("Request failure", "Ivalid response"), bag: bag)
//            case .deserializationFailed:
//                coordinator.displayAlert(errorData: ("Deserialization failure", "Decodable fail"), bag: bag)
//            case .noConnection:
//                coordinator.displayAlert(errorData: ("Looking for internet connection...", "Internet connection failure"), bag: bag)
//            }
//        case let location as ApplicationErrors.Location:
//            switch location {
//            case .noPermission:
//                coordinator.displayAlert(errorData: ("Please provide access to location services in Settings app", "No location access"), bag: bag)
//            }
//        default: break
//        }
//        return nil
    }
}
