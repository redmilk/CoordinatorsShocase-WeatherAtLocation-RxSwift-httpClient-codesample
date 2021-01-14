//
//  OptionalUnwrap+Rx.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import RxSwift

extension Observable {

    /// Returns an `Observable` where the nil values from the original `Observable` are skipped
    func unwrap<T>() -> Observable<T> where Element == T? {
        self
            .filter { $0 != nil }
            .map { $0! }
    }
}
