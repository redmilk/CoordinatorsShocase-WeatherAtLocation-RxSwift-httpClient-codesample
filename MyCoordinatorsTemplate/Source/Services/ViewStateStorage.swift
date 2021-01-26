//
//  StateStore.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 01.11.2020.
//

import RxSwift
import RxCocoa

// TODO: - make protocol for writing to state, same for reading
/// we can avoid this storage and put state directly to ViewController
/// but this storage allows us to provide state saving in future
/// also it's must have part for flux architecture
/// can be replaced by RxFeedback

final class ViewStateStorage {
    
    public let mainSceneState: BehaviorSubject<WeatherSceneState>
    
    init() {
        mainSceneState = BehaviorSubject<WeatherSceneState>(value: WeatherSceneState.initial)
    }
}
