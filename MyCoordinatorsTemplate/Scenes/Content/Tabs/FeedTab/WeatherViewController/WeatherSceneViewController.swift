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
    
    private let stateStorage: ViewStateStorage
    private(set) var viewModel: WeatherSceneViewModel
    private var disposeBag: DisposeBag!
        
    required init?(viewModel: WeatherSceneViewModel,
                   stateStorage: ViewStateStorage,
                   coder: NSCoder
    ) {
        self.viewModel = viewModel
        self.stateStorage = stateStorage
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        disposeBag = DisposeBag()
        /// Output
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
        
        /// Input from state
        let state = viewModel.output.actualState
            .observe(on: MainScheduler.instance)
            .share(replay: 1)
        
        state
            .flatMap { $0.searchText }
            .asDriver(onErrorJustReturn: "")
            .drive(searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        state
            .flatMap { $0.temperature }
            .asDriver(onErrorJustReturn: "")
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        state
            .flatMap { $0.humidity }
            .asDriver(onErrorJustReturn: "")
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        state
            .flatMap { $0.searchText }
            .asDriver(onErrorJustReturn: "")
            .drive(weatherIconLabel.rx.text)
            .disposed(by: disposeBag)
        
        let loading = state
            .flatMap { $0.isLoading }
            .startWith(false)
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
            .disposed(by: disposeBag)        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = nil
    }
}
