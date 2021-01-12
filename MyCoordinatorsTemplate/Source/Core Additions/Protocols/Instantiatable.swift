//
//  Storyboarded.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

enum Instantiate {
    case initial
    case withIdentifier
}

protocol Instantiatable {
    static func instantiate(storyboard: Storyboard,
                                      instantiation with: Instantiate,
                                      creator: @escaping (NSCoder) -> UIViewController
    ) -> Self
}

extension Instantiatable where Self: UIViewController {
    static func instantiate(storyboard: Storyboard,
                                      instantiation with: Instantiate,
                                      creator: @escaping (NSCoder) -> UIViewController
    ) -> Self {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        switch with {
        case .initial:
            return storyboard.instantiateInitialViewController(creator: creator) as! Self
        case .withIdentifier:
            let id = String(describing: self)
            return storyboard.instantiateViewController(identifier: id, creator: creator) as! Self
        }
    }
}
