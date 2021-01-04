//
//  NoStoryDraggableWithNoCode.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

class NoStoryboardedController: ViewController {
        
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

    // MARK: - Lifecycle
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifcationListenerForScrollView(scrollView)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationListeners()
    }
    
    // MARK: - Inner stack view helpers
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
    
}

