//
//  NoStoryViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 29.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class NoStoryDraggableViewController: ViewController {
        
    public let percentThresholdDismiss: CGFloat = 0.3
    public var velocityDismiss: CGFloat = 300
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var backgroundDismissColor: UIColor = .black {
        didSet {
            navigationController?.view.backgroundColor = backgroundDismissColor
        }
    }
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .top
        return view
    }()

    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        return view
    }()

    override func loadView() {
        let view = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let topConstraint = stackView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let bottomConstraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor)

        topConstraint.priority = UILayoutPriority.required
        bottomConstraint.priority = UILayoutPriority.defaultLow

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0)
        ])
        
        self.view = view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifcationListenerForScrollView(scrollView)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationListeners()
    }
    
    public func addStackedView(view: UIView) {
        stackView.addArrangedSubview(view)
    }

    public func addStackedViews(views: [UIView]) {
        for view in views {
            addStackedView(view: view)
        }
    }

    public func removeStackedView(view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    public func insertStackedView(view: UIView, at index: Int) {
        stackView.insertArrangedSubview(view, at: index)
    }
    
    @objc fileprivate func onDrag(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let movementOnAxis: CGFloat
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
