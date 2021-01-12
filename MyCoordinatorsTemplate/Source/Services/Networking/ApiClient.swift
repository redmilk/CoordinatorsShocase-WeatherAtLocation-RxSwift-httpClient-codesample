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

protocol ApiRequestable {
    func request<Decodabl: Decodable>(method: String,
                 pathComponent: String,
                 params: [(String, String)],
                 maxRetry: Int) -> Observable<Decodabl>
}

extension ApiClient: ReachabilitySupporting { }

final class ApiClient: ApiRequestable {
    
    private let apiKey = BehaviorSubject<String>(value: "66687e09dee0508032ac82d5785ee2ad")
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let bag = DisposeBag()
    static let requestRetryMessage = BehaviorRelay<String>(value: "")
    
    init() {
//        Logging.URLRequests = { request in
//            return true
//        }
    }
  
    func request<D: Decodable>(method: String = "GET", pathComponent: String, params: [(String, String)], maxRetry: Int) -> Observable<D> {
        let request = buildRequest(method: method, pathComponent: pathComponent, params: params)
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
                ApiClient.requestRetryMessage.accept("🟥🟥🟥 Retry attempt: \(count + 1)")
                return Observable<Int>
                    .timer(RxTimeInterval.milliseconds(2000), scheduler: MainScheduler.instance)
                    .take(1)
            }
        }
        return URLSession.shared.rx
            .decodable(request: request, type: D.self)
            .retry(when: retryHandler)
    }
    
    private func buildRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> URLRequest {
        let url = baseURL.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "appid", value: try? apiKey.value())
        let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" {
            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            queryItems.append(keyQueryItem)
            queryItems.append(unitsQueryItem)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = [keyQueryItem, unitsQueryItem]
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
