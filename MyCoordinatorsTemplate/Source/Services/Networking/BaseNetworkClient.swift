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
 All of these is just my opinion, I'm sure you will find some inaccuracies or you know better solutions, will appreciate to discuss and consolidate this knowledge. I'm always looking for ways of better myself and grateful for the new aprroaches gained from my collegues :]
 
 Introduction helper of current tab:
 
 - Coordinator pattern demo with base coordinator as the only place for addopting to navigation controller and tabbar delegates. Handling default os navbar interactions, different presentation modes available from any spot of the application. Auto clean-up after coordinator's end. Absence of memory leaks.
 
 - User session demo with user obfuscation and keychain.
 
   saving flow: user id --> obfuscation --> to data --> to UserDefaults --| user model --> to data --> to KeyChain
 
   fetching flow: UserDefault get --> data --> [UInt8] --> obfuscation to userId --> get from keychain --> data --> User model
 
 // TODO: - remove
 
 Introduction helper of current tab:

 - Flux + Rx demo, state as single source of truth for view controller, the only difference is - it has separated state storages for
   every screen and reducers in view model
 
 - Location service with permissions and ongoing permission change cases
 
 - List of available networking errors handling
 
 - Automatic token recovering on error 401 with further failed request retrying
 
 - Request caching for saving traffic and better scene response
   (unless data needs to be up-to-date on every similar request, also we can configure time of cache keeping)
 
 - Request retrying attempts on errors (unless 401 and -1009 which are handled individually)
 
 - No-internet-connection handling and auto retry when connection appears
  
 - Request cancelation
  
 */

// TODO: - all screen clean code

typealias RetryHandler = (Observable<Error>) -> Observable<Int>
typealias Response = (URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>

final class BaseNetworkClient {
        
    public func getData<T>(response: @escaping Response,
                           tokenAcquisitionService: TokenRecovering<T>,
                           request: @escaping (T) throws -> URLRequest
    ) -> Observable<(response: HTTPURLResponse, data: Data)> {
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

extension ObservableConvertibleType where Element == Error {
    func renewToken<T>(with service: TokenRecovering<T>) -> Observable<Void> {
        return service.trackErrors(for: self)
    }
}
