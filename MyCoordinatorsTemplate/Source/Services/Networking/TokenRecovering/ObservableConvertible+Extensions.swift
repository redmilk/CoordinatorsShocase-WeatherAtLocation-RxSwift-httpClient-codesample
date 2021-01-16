//
//  ObservableConvertibleType+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 16.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import RxSwift

extension ObservableConvertibleType where Element == Error {
    func renewToken<T>(with service: TokenRecoverService<T>) -> Observable<Void> {
        return service.trackErrors(for: self)
    }
}
