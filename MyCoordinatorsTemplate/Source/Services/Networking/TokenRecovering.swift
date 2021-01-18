//
//  RefreshTokenRetriever.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 16.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation
import RxSwift

final class TokenRecovering<T> {

    var token: Observable<T> {
        return _token.asObservable()
    }

    typealias GetToken = (T) -> Observable<(response: HTTPURLResponse, data: Data)>

    init(initialToken: T, getToken: @escaping GetToken, extractToken: @escaping (Data) throws -> T) {
        relay
            .flatMapFirst { getToken($0) }
            .map { (urlResponse) -> T in
                guard urlResponse.response.statusCode / 100 == 2 else { throw ApplicationErrors.TokenRecoverError.getTokenFailure(response: urlResponse.response, data: urlResponse.data) }
                return try extractToken(urlResponse.data)
            }
            .startWith(initialToken)
            .subscribe(_token)
            .disposed(by: disposeBag)
    }

    func setToken(_ token: T) {
        lock.lock()
        _token.onNext(token)
        lock.unlock()
    }

    func trackErrors<O: ObservableConvertibleType>(for source: O) -> Observable<Void> where O.Element == Error {
        let lock = self.lock
        let relay = self.relay
        let error = source
            .asObservable()
            .map { error in
                guard (error as? ApplicationErrors.TokenRecoverError) == .unauthorized else { throw error }
            }
            .flatMap { [unowned self] in  self.token }
            .do(onNext: {
                lock.lock()
                relay.onNext($0)
                lock.unlock()
            })
            .filter { _ in false }
            .map { _ in }

        return Observable.merge(token.skip(1).map { _ in }, error)
    }

    private let _token = ReplaySubject<T>.create(bufferSize: 1)
    private let relay = PublishSubject<T>()
    private let lock = NSRecursiveLock()
    private let disposeBag = DisposeBag()
}
