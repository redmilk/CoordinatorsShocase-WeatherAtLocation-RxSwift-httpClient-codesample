//
//  StateStore.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 01.11.2020.
//

import RxSwift
import RxCocoa

protocol StateStoreWriting { }
extension StateStoreWriting { }
protocol StateStoreFetching { }

final class StateStore {
    
    public let mainSceneState: BehaviorSubject<MainSceneState>
    
    init() {
        mainSceneState = BehaviorSubject<MainSceneState>(value: MainSceneState.initial)
    }
    
    private let bag = DisposeBag()
    
}
