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


/// implementation
class WeatherSceneViewModel {
    
    /// we could use Rx Actions here for simplicity, but it's additional project dependency
    enum Action {
        case getWeatherBy(city: String)
        case currentLocationWeather
        case cancelRequest
        case none
    }
    
    /// input from VC, output to view states storage
    struct Input {
        var action = PublishSubject<Action>()
    }
    
    /// input from view
    var input = Input()
    
    /// bind actions from VC
    private func bindActions() {
        disposeBag = DisposeBag()
        input.action
            .asObservable()
            .subscribe(onNext: { [unowned self] action in
                /// fetch current state
                let newState = self.currentState
                
                switch action {
                /// city search weather
                case .getWeatherBy(let city):
                    let weather = self.weatherService.weather(by: city)
                    self.reduce(weather, state: newState, disposeBag: self.disposeBag)
                    
                /// current location weather
                case .currentLocationWeather:
                    let weather = self.weatherService.weatherByCurrentLocation()
                    self.reduce(weather, state: newState, disposeBag: self.disposeBag)
                    
                /// cancel current action
                case .cancelRequest:
                    self.terminate()
                    
                case .none:
                    break
                }
            })
            .disposed(by: self.disposeBag)
        
        /// debug messages output for api calls
        weatherService.requestRetryMessage
            .subscribe(onNext: { [unowned self] msg in
                let state = currentState
                state.requestRetryText.accept(msg)
            })
            .disposed(by: disposeBag)
    }
    
    init(coordinator: WeatherCoordinator,
         weatherService: WeatherServiceProtocol,
         stateStorageWriter: WeatherStateStorageWritable
    ) {
        self.coordinator = coordinator
        self.weatherService = weatherService
        self.stateStorageWriter = stateStorageWriter
        bindActions()
    }
    
    /// Reduce view state with new data
    private func reduce(_ weather: Observable<Weather>, state: WeatherSceneState, disposeBag: DisposeBag) {
        state.isLoading.accept(true)
        return weather
            .take(1)
            .map { (weather) -> WeatherSceneState in
                state.isLoading.accept(false)
                state.updateWeather(weather)
                return state.formatted
            }
            .catch { [unowned self] error in
                state.isLoading.accept(false)
                self.handleError(error)
                return Observable.just(state)
            }
            .bind(to: stateStorageWriter.weatherViewState)
            .disposed(by: disposeBag)
    }
    
    /// Dispatching errors
    private func handleError(_ error: Error) {
        guard let error = error as? ApplicationError else { return }
        coordinator.displayAlert(error: error, bag: disposeBag)
    }
    
    /// Cancel current action
    private func terminate() {
        self.bindActions()
        self.weatherService.terminateRequest()
        let newState = currentState
        newState.isLoading.accept(false)
        self.stateStorageWriter.weatherViewState.accept(newState)
    }
    
    /// VM dependencies
    private let coordinator: WeatherCoordinator
    private let weatherService: WeatherServiceProtocol
    private let stateStorageWriter: WeatherStateStorageWritable
    
    /// internal
    private var disposeBag = DisposeBag()
    private var currentState: WeatherSceneState {
        return self.stateStorageWriter.weatherViewState.value
    }
}
