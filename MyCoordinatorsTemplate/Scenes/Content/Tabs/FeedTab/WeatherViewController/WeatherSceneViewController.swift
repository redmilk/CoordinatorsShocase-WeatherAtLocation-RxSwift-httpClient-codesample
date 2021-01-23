//
//  MainSceneViewController.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 30.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: - Provide different error types and handle them at once in VC
// TODO: - Location permission Alert
// TODO: - Show info view on request retry
// TODO: - Maybe state should be shared, some of observables must be shared to prevent multiple handlers executing
// TODO: - Cache/Fetch cache on error
// TODO: - Letter appear animation

/// access to current state of view
extension WeatherSceneViewController: StateStorageAccassible { }

final class WeatherSceneViewController: ViewController, Instantiatable, BindableType {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var weatherIconLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var cancelRequestButton: UIButton!
    @IBOutlet private weak var mapButton: UIButton!
    
    var viewModel: WeatherSceneViewModel!
    private var bag = DisposeBag()
        
    required init?(viewModel: WeatherSceneViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        /// Output
        locationButton.rx.controlEvent(.touchUpInside)
            .map { WeatherSceneViewModel.Action.currentLocationWeather }
            .bind(to: viewModel.input.action)
            .disposed(by: bag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { [weak self] in self?.searchTextField.text }
            .unwrap()
            .map { WeatherSceneViewModel.Action.getWeatherBy(city: $0) }
            .bind(to: viewModel.input.action)
            .disposed(by: bag)
        
        cancelRequestButton.rx.controlEvent(.touchUpInside)
            .map { WeatherSceneViewModel.Action.cancelRequest }
            .bind(to: viewModel.input.action)
            .disposed(by: bag)
        
        /// Input from state
        let state = store
            .mainSceneState
            .observe(on: MainScheduler.instance)
            .share(replay: 1)
        
        state
            .flatMap { $0.searchText }
            .asDriver(onErrorJustReturn: "")
            .drive(searchTextField.rx.text)
            .disposed(by: bag)
        
        state
            .flatMap { $0.temperature }
            .asDriver(onErrorJustReturn: "")
            .drive(tempLabel.rx.text)
            .disposed(by: bag)
        
        state
            .flatMap { $0.humidity }
            .asDriver(onErrorJustReturn: "")
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)
        
        state
            .flatMap { $0.searchText }
            .asDriver(onErrorJustReturn: "")
            .drive(weatherIconLabel.rx.text)
            .disposed(by: bag)
        
        let loading = state
            .flatMap { $0.isLoading }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        loading
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .map { !$0 }
            .drive(locationButton.rx.isEnabled)
            .disposed(by: bag)
        
        loading
            .map { !$0 }
            .drive(searchTextField.rx.isEnabled)
            .disposed(by: bag)
        
        loading
            .map { !$0 }
            .drive(cancelRequestButton.rx.isHidden)
            .disposed(by: bag)
        
        loading
            .map { !$0 }
            .drive(mapButton.rx.isEnabled)
            .disposed(by: bag)
        
        /// TODO: - ????
        /// retry text alert for debug
        state
            .flatMap { $0.requestRetryText }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] msg in
                self?.errorLabel.text = msg
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.errorLabel.text = ""
                }
            })
            .disposed(by: bag)
        
        /// error parsing at view model
        /// TODO: - presenting error from coordinator
        state.flatMap { $0.errorAlertContent }
            .unwrap()
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (errorData: (msg: String, title: String)) -> Void in
                guard let self = self else { return }
                switch errorData.title {
                case "No location access":
                    self.present(alertWithActionAndText: errorData.msg, title: "Go to Settings", actionTitle: errorData.title) {
                        Utils.openSettings()
                    }
                    .subscribe()
                    .disposed(by: self.bag)
                case _:
                    self.present(simpleAlertWithText: errorData.msg, title: errorData.title)
                        .subscribe()
                        .disposed(by: self.bag)
                }
            })
            .disposed(by: bag)
    }
}
