//
//  StateStore.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 01.11.2020.
//

import RxSwift
import RxCocoa

// MARK: - Weather state access
protocol WeatherStateStorageWritable {
    var weatherViewState: BehaviorRelay<WeatherSceneState> { get }
}
protocol WeatherStateStorageReadable {
    var weatherViewStateRead: Driver<WeatherSceneState> { get }
}

/// we can avoid this storage and put states directly to VC from VM
/// but this storage allows us to provide state saving in future
/// f.e. into RxRealm, and it is convenient to cache view state when VC deinit
/// also it's one of the main part for flux architecture
/// can be replaced by RxFeedback

final class StateStorage: WeatherStateStorageWritable,
                          WeatherStateStorageReadable {
    
    var weatherViewStateRead: Driver<WeatherSceneState> {
        return weatherViewState.asDriver(onErrorJustReturn: .initial)
    }
    
    let weatherViewState = BehaviorRelay<WeatherSceneState>(value: WeatherSceneState.initial)
}
