//
//  StateContentFormattable.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 05.11.2020.
//

import Foundation

protocol StateContentFormattable {
    associatedtype State
    func format(state: State) -> State
}
