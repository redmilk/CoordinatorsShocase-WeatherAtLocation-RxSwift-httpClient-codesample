//
//  LastNameViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 08.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

// MARK: - Capabilities
extension LastNameViewController: Instantiatable { }

final class LastNameViewController: ViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    
    private let viewModel: LastNameViewModelProtocol
        
    required init?(viewModel: LastNameViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        title = viewModel.vcTitle
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTextSourceFieldToConvenienceKeyboardHidingList(textFields: [lastNameTextField])
        setupKeyboardNotifcationListenerForScrollView(scrollView)
        lastNameTextField.text = viewModel.user.lastName
        containerHeightConstraint.constant = calculatedContentHeight

    }
    
    override func handleDefaultModalDismissing() {
        viewModel.dismissAuthFlow()
    }

    @IBAction func nextPressed(_ sender: Any) {
        viewModel.nextStep()
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        viewModel.setLastName(sender.text)
    }
}
