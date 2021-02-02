//
//  UIViewController+Rx.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 03.11.2020.
//

import UIKit
import RxSwift

extension UIViewController {
    func present(simpleAlertWithText text: String, title: String) -> Completable {
        Completable.create { (completable) -> Disposable in
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                completable(.completed)
            }))
            self.present(alert, animated: true, completion: nil)
            return Disposables.create {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func present(alertWithActionAndText text: String, title: String, actionTitle: String, action: @escaping () -> Void) -> Completable {
        Completable.create { (completable) -> Disposable in
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                completable(.completed)
            }))
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                action()
                completable(.completed)
            }))
            self.present(alert, animated: true, completion: nil)
            return Disposables.create {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
