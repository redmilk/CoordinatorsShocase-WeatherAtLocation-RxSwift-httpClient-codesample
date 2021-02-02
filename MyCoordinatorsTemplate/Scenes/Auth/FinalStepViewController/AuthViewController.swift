//
//  AuthViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class AuthViewController: ViewController, Instantiatable, Sessionable {
    
    @IBOutlet private weak var userNameLabel: UILabel!
    
    private let viewModel: AuthViewModelProtocol
    
    required init?(viewModel: AuthViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        title = viewModel.title
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = viewModel.user.fullName
    }
 
    override func handleDefaultModalDismissing() {
        viewModel.dismissAuthFlow()
    }
    
    @IBAction func saveUserPressed(_ sender: Any) {
        viewModel.performLogIn(completion: { () -> Bool in
            return true
        })
    }
}
