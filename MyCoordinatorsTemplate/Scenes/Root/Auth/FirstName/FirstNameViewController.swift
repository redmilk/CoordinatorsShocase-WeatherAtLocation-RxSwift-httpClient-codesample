//
//  FirstNameViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 08.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

// MARK: - Capabilities
extension FirstNameViewController: Instantiatable { }

final class FirstNameViewController: ViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var contentHeightConstraint: NSLayoutConstraint!
    
    private let viewModel: FirstNameViewModelProtocol
        
    required init?(viewModel: FirstNameViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        self.title = viewModel.vcTitle
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifcationListenerForScrollView(scrollView)
        addTextSourceFieldToConvenienceKeyboardHidingList(textFields: [firstNameTextField])
        /// for keyboard scrolling demonstration purpose supporting all screen sizes and presentation modes
        contentHeightConstraint.constant = calculatedContentHeight
    }
    
    override func handleDefaultModalDismissing() {
        viewModel.dismissAuthFlow()
    }

    @IBAction func nextPressed(_ sender: Any) {
        viewModel.nextStep()
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        viewModel.setFirstName(sender.text)
    }
}
