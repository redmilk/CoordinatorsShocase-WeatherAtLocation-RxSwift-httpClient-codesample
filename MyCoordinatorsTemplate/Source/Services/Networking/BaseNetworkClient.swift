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

/**
 
 // TODO: - remove
 
 - Full list of networking errors handling
 
 - Automatic token recovering on error 401 with further failed request retrying
 
 - Request caching for saving traffic and better scene response
   (unless data needs to be up-to-date on every similar request, also we can configure time of cache keeping)
 
 - Request retrying attempts on errors (unless 401 and -1009 which are handled individually)
 
 - No-internet-connection handling and auto retry when connection appears
  
 - Request cancelation
  
 */

public typealias RetryHandler = (Observable<Error>) -> Observable<Int>

final class BaseNetworkClient {
        
    public typealias Response = (URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>

    /// Builds and makes network requests using the token provided by the service. Will request a new token and retry if the result is an unauthorized (401) error.
    ///
    /// - Parameters:
    ///   - response: A function that sends requests to the network and emits responses. Can be for example `URLSession.shared.rx.response`
    ///   - tokenAcquisitionService: The object responsible for tracking the auth token. All requests should use the same object.
    ///   - request: A function that can build the request when given a token.
    /// - Returns: response of a guaranteed authorized network request.
    public func getData<T>(response: @escaping Response, tokenAcquisitionService: TokenRecoverService<T>, request: @escaping (T) throws -> URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable
            .deferred { tokenAcquisitionService.token.take(1) }
            .map { try request($0) }
            .flatMap { response($0) }
            .map { response in
                guard response.response.statusCode != 401 else { throw ApplicationErrors.TokenRecoverError.unauthorized }
                return response
            }
            .retry { $0.renewToken(with: tokenAcquisitionService) }
    }
        
    func request<D: Decodable>(with request: URLRequest,
                               retryHandler: @escaping RetryHandler) -> Observable<D> {
     
        /// request execution
        return URLSession.shared.rx
            .decodable(request: request, type: D.self)
            .retry(when: retryHandler)
    }
    
}
