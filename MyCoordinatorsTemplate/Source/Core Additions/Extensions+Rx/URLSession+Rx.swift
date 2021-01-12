//
//  URLSession+Rx.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 11.11.2020.
//

import RxSwift
import Foundation
import UIKit

fileprivate var internalCache = [String: Data]()

extension ObservableType where Element == (response: HTTPURLResponse, data: Data) {
    func cache() -> Observable<Element> {
        return self.do(onNext: { response, data in
            guard let url = response.url?.absoluteString,
                  200..<300 ~= response.statusCode else { return }
            internalCache[url] = data
        })
    }
}

extension Reactive where Base: URLSession {

    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { observer in
            let task = self.base.dataTask(with: request) { (data, response, error) in
                guard let response = response,
                      let data = data else {
                    let err = ApplicationErrors.ApiClient.serverError
                    observer.onError(err)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(ApplicationErrors.ApiClient.invalidResponse)
                    return
                }
                observer.onNext((httpResponse, data))
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create() { task.cancel() }
        }
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        if let url = request.url?.absoluteString,
           let data = internalCache[url] {
            return Observable.just(data)
        }
        return response(request: request)
            .cache()
            .map { response, data -> Data in
                switch response.statusCode {
                case 200..<300:
                    return data
                case 401:
                    throw ApplicationErrors.ApiClient.invalidToken
                case 404:
                    throw ApplicationErrors.ApiClient.notFound
                case 400..<500:
                    throw ApplicationErrors.ApiClient.serverError
                default:
                    throw ApplicationErrors.ApiClient.serverError
                }
            }
    }
    
    func string(request: URLRequest) -> Observable<String> {
        return data(request: request).map { data in
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    func json(request: URLRequest) -> Observable<Any> {
        return data(request: request).map { data in
            return try JSONSerialization.jsonObject(with: data)
        }
    }
    
    func decodable<D: Decodable>(request: URLRequest, type: D.Type) -> Observable<D> {
        return data(request: request).map { data in
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(type, from: data)
            } catch {
                throw ApplicationErrors.ApiClient.deserializationFailed
            }
        }
    }
    
    func image(request: URLRequest) -> Observable<UIImage> {
        return data(request: request).map { data in
            guard let image = UIImage(data: data) else {
                throw ApplicationErrors.ApiClient.deserializationFailed
            }
            return image
        }
    }
}
