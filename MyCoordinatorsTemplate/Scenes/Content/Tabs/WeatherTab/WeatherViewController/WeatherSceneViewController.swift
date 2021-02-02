//
//  MainSceneViewController.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 30.10.2020.
//

import UIKit
import RxSwift
import RxCocoa


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
    
    private let stateStorageReader: WeatherStateStorageReadable
    private(set) var viewModel: WeatherSceneViewModel
    private var disposeBag: DisposeBag!
        
    required init?(viewModel: WeatherSceneViewModel,
                   stateStorageReader: WeatherStateStorageReadable,
                   coder: NSCoder
    ) {
        self.viewModel = viewModel
        self.stateStorageReader = stateStorageReader
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        disposeBag = DisposeBag()
        
        /// Output to VM
        locationButton.rx.controlEvent(.touchUpInside)
            .map { WeatherSceneViewModel.Action.currentLocationWeather }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { [weak self] in self?.searchTextField.text }
            .unwrap()
            .map { WeatherSceneViewModel.Action.getWeatherBy(city: $0) }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
        
        cancelRequestButton.rx.controlEvent(.touchUpInside)
            .map { WeatherSceneViewModel.Action.cancelRequest }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
        
        /// Input from view state storage
        stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.searchText.asDriver() }
            .drive(searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.temperature.asDriver() }
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.humidity.asDriver() }
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.searchText.asDriver() }
            .drive(weatherIconLabel.rx.text)
            .disposed(by: disposeBag)
        
        let loading = stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.isLoading.asDriver() }
            .asDriver(onErrorJustReturn: false)
        
        loading
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        loading
            .map { !$0 }
            .drive(locationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loading
            .map { !$0 }
            .drive(searchTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loading
            .map { !$0 }
            .drive(cancelRequestButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        loading
            .map { !$0 }
            .drive(mapButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        stateStorageReader
            .weatherViewStateRead
            .flatMap { $0.requestRetryText.asDriver() }
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = nil
    }
}
