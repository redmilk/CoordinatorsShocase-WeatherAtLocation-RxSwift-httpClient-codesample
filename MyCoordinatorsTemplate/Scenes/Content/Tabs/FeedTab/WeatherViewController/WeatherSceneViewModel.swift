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

/// view model types
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
        var actualState = BehaviorSubject<WeatherSceneState>(value: .initial)
    }
}


/// capabilities
/// Access to state store
//extension WeatherSceneViewModel: StateStorageAccassible { }

/// implementation
class WeatherSceneViewModel {
    
    /// input from view
    var input = Input(action: PublishSubject<Action>())
    var output = Output()
    
    private func bindActions() {
        disposeBag = DisposeBag()
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
                    self.reduce(weather, state: newState, disposeBag: self.disposeBag)
                    
                /// current location weather
                case .currentLocationWeather:
                    let weather = self.weatherService.weatherByCurrentLocation()
                    self.reduce(weather, state: newState, disposeBag: self.disposeBag)
                    
                case .cancelRequest:
                    self.terminate()
                    
                case .none:
                    break
                }
            })
            .disposed(by: self.disposeBag)
        
        /// debug
        weatherService.requestRetryMessage
            .subscribe(onNext: { [unowned self] msg in
                let state = (try? self.output.actualState.value()) ?? .initial
                state.requestRetryText.onNext(msg)
            })
            .disposed(by: disposeBag)
    }
    
    init(coordinator: WeatherCoordinator,
         weatherService: WeatherServiceType
    ) {
        self.coordinator = coordinator
        self.weatherService = weatherService
        bindActions()
    }
    
    private func reduce(_ weather: Observable<Weather>, state: WeatherSceneState, disposeBag: DisposeBag) {
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
            .disposed(by: disposeBag)
    }
    
    private func terminate() {
        self.bindActions()
        self.weatherService.terminateRequest()
        let newState = currentState
        newState.isLoading.onNext(false)
        newState.errorAlertContent.onNext(nil)
        self.output.actualState.onNext(newState)
    }
        
    private let coordinator: WeatherCoordinator
    private let weatherService: WeatherServiceType
    private var disposeBag = DisposeBag()
    private var currentState: WeatherSceneState {
        return (try? self.output.actualState.value())!
    }
}


// MARK: Error handling
extension WeatherSceneViewModel: ErrorHandling {
    
    @discardableResult
    func handleError(_ error: Error) -> (String, String)? {
        guard let error = error as? ApplicationError,
              let errorInfo = error.errorInfo else { return nil }
        coordinator.displayAlert(errorData: errorInfo, bag: disposeBag)
        return errorInfo
    }
}
