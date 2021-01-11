//
//  PersonalInfoViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class PersonalInfoViewController: ViewController, Instantiatable {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    private let viewModel: PersonalInfoViewModelProtocol
    
    required init?(viewModel: PersonalInfoViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        title = viewModel.vcTitle
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = viewModel.fullName
    }
    
    override func handleDefaultModalDismissing() {
        viewModel.dismiss()
    }
    
    
}
