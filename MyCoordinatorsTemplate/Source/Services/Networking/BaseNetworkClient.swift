//
//  ApiClient.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 30.10.2020.
//

import RxSwift
import RxCocoa
import CoreLocation
import MapKit

fileprivate var internalCache = [String: Data]()

extension BaseNetworkClient: ReachabilitySupporting { }

final class BaseNetworkClient {
    
    private let bag = DisposeBag()
    static let requestRetryMessage = BehaviorRelay<String>(value: "")
    
    func request<D: Decodable>(with request: URLRequest,
                               maxRetry: Int) -> Observable<D> {
        let retryHandler: (Observable<Error>) -> Observable<Int> = { err in
            return err.enumerated().flatMap { count, error -> Observable<Int> in
                if count >= maxRetry - 1 {
                    return Observable.error(error)
                } else if (error as NSError).code == -1009 {
                    return self.reachability
                        .status
                        .map { (status: Reachability.Status) -> Bool in
                            return status == .online
                        }
                        .distinctUntilChanged()
                        .filter { $0 == true }
                        .map { _ in 1 }
                }
                BaseNetworkClient.requestRetryMessage.accept("🟥🟥🟥 Retry attempt: \(count + 1)")
                return Observable<Int>
                    .timer(RxTimeInterval.milliseconds(2000), scheduler: MainScheduler.instance)
                    .take(1)
            }
        }
        return URLSession.shared.rx
            .decodable(request: request, type: D.self)
            .retry(when: retryHandler)
    }
}
