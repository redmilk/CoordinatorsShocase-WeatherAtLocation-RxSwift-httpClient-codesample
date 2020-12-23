//
//  DraggableViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

public class DraggableViewController: UIViewController {

    public let percentThresholdDismiss: CGFloat = 0.3
    public var velocityDismiss: CGFloat = 300
    public var axis: NSLayoutConstraint.Axis = .horizontal
    public var backgroundDismissColor: UIColor = .black {
        didSet {
            navigationController?.view.backgroundColor = backgroundDismissColor
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:))))
    }

    @objc fileprivate func onDrag(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // Movement indication index
        let movementOnAxis: CGFloat
        // Move view to new position
        switch axis {
        case .vertical:
            let newY = min(max(view.frame.minY + translation.y, 0), view.frame.maxY)
            movementOnAxis = newY / view.bounds.height
            view.frame.origin.y = newY

        case .horizontal:
            let newX = min(max(view.frame.minX + translation.x, 0), view.frame.maxX)
            movementOnAxis = newX / view.bounds.width
            view.frame.origin.x = newX
        @unknown default:
            fatalError()
        }

        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        let progress = CGFloat(positiveMovementOnAxisPercent)
        navigationController?.view.backgroundColor = UIColor.black.withAlphaComponent(1 - progress)

        switch sender.state {
        case .ended where sender.velocity(in: view).y >= velocityDismiss || progress > percentThresholdDismiss:
            // After animate, user made the conditions to leave
            UIView.animate(withDuration: 0.2, animations: {
                switch self.axis {
                case .vertical:
                    self.view.frame.origin.y = self.view.bounds.height

                case .horizontal:
                    self.view.frame.origin.x = self.view.bounds.width
                @unknown default:
                    fatalError()
                }
                self.navigationController?.view.backgroundColor = UIColor.black.withAlphaComponent(0)

            }, completion: { finish in
                self.dismiss(animated: true)
            })
        case .ended:
            // Revert animation
            UIView.animate(withDuration: 0.2, animations: {
                switch self.axis {
                case .vertical:
                    self.view.frame.origin.y = 0

                case .horizontal:
                    self.view.frame.origin.x = 0
                @unknown default:
                    fatalError()
                }
            })
        default:
            break
        }
        sender.setTranslation(.zero, in: view)
    }
}
