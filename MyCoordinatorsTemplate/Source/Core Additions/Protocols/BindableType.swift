//
//  BindableType.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol BindableType {
  associatedtype ViewModelType
  var viewModel: ViewModelType { get }
  func bindViewModel()
}

extension BindableType where Self: UIViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    loadViewIfNeeded()
    bindViewModel()
  }
}
