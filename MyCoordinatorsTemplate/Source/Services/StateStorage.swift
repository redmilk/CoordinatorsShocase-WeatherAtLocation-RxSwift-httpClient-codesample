//
//  StateStore.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 01.11.2020.
//

import RxSwift
import RxCocoa

final class StateStorage {
    
    public let mainSceneState: BehaviorSubject<WeatherSceneState>
    
    init() {
        mainSceneState = BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial)
    }
    
    private let bag = DisposeBag()
    
}
