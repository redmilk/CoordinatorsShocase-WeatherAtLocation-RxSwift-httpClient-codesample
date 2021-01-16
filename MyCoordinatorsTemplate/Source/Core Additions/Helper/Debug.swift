//
//  Debug.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 16.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation
import RxSwift

struct TokenFetcherExample {
    
    func getAccessToken() -> Observable<(response: HTTPURLResponse, data: Data)> {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = "{\"token\":\"123123token3234234\",\"uid\":\"999999\"}".data(using: .utf8)!
        return Observable.just((response: response, data: data)).delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    
    func getWrongAccessToken() -> Observable<(response: HTTPURLResponse, data: Data)> {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 401, httpVersion: nil, headerFields: nil)!
        let data = "{\"token\":\"123123token3234234\",\"uid\":\"999999\"}".data(using: .utf8)!
        return Observable.just((response: response, data: data)).delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    
}
