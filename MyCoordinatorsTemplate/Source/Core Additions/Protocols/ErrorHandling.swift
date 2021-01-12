//
//  ErrorHandling.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 05.11.2020.
//

import RxSwift

protocol ErrorHandling {
    typealias ErrorContent = (String, String)?
    func handleError(_ error: Error) -> ErrorContent
}
