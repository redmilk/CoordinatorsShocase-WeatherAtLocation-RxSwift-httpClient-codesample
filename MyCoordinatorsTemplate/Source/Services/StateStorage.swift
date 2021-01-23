//
//  StateStore.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 01.11.2020.
//

import RxSwift
import RxCocoa

// TODO: - make protocol for writing to state, same for reading
final class StateStorage {
    
    public let mainSceneState: BehaviorSubject<WeatherSceneState>
    
    init() {
        mainSceneState = BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial)
    }
}
