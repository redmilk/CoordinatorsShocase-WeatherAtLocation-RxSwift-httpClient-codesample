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


typealias RetryHandler = (Observable<Error>) -> Observable<Int>
typealias Response = (URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>

final class BaseNetworkClient {
    func request<D: Decodable>(with request: URLRequest,
                               retryHandler: @escaping RetryHandler) -> Observable<D> {
     
        /// request execution
        return URLSession.shared.rx
            .decodable(request: request, type: D.self)
            .retry(when: retryHandler)
    }
}
