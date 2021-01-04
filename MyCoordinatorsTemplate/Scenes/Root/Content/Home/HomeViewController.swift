//
//  HomeViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController, Instantiatable {

    private let viewModel: HomeViewModelProtocol
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    init?(title: String, viewModel: HomeViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        self.title = title
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if coordinator?.navigationController?.delegate != nil  {
//            //Logger.log(entity: coordinator?.navigationController?.delegate)
//        } else {
//            print("HomeViewController Navigation delegate NIL")
//        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        isLoggedIn = false
        viewModel.displayAuth()
    }
    
    @IBAction func pushProfilePressed(_ sender: Any) {
        viewModel.pushProfile()
    }
    
    @IBAction func presentProfilePressed(_ sender: Any) {
        viewModel.presentProfile()
    }
    
    @IBAction func presentAuthPressed(_ sender: Any) {
        
    }
    
    @IBAction func presentFormsPressed(_ sender: Any) {
        
    }
    
}
