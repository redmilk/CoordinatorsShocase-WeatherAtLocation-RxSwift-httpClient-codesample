//
//  DeepLinkOpener.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 07.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// closure wrapper for obj-c collection types
final class Box<T> {
    let obj: T
    init(obj: T) {
        self.obj = obj
    }
}

final class DeepLinkService {

    typealias FeatureProvider = (URL) -> UIViewController?
    typealias FeatureProviderBox = Box<FeatureProvider>

    lazy var providers = NSMapTable<AnyObject, NSHashTable<FeatureProviderBox>>.weakToStrongObjects()

    func register(featureProvider: @escaping FeatureProvider, forObject object: AnyObject) {
        if providers.object(forKey: object) == nil {
            providers.setObject(NSHashTable(), forKey: object)
        }
        let box = FeatureProviderBox(obj: featureProvider)
        providers.object(forKey: object)?.add(box)
    }

    func feature(forUrl url: URL) -> UIViewController? {
        let allValues = providers.objectEnumerator()
        while let table = allValues?.nextObject() as? NSHashTable<FeatureProviderBox> {
            if let feature = table.allObjects.lazy.compactMap({ $0.obj(url) }).first {
                return feature
            }
        }
        return nil
    }
}
