//
//  FeedCustomViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 02.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class FeedCustomViewController: StackViewWithScrollViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let red = UILabel()
        red.backgroundColor = .red
        let black = UILabel()
        black.backgroundColor = .black
        black.textColor = .white
        let purple = UILabel()
        purple.backgroundColor = .magenta
        
        let textfield = UITextField()
        textfield.text = "Text input..."
        textfield.backgroundColor = .blue
        textfield.font = UIFont.systemFont(ofSize: 22.0)
        textfield.textColor = .white
        textfield.delegate = self
        addStackedViews(views: [red, black, purple, textfield])
        
        textFieldsArrayForFreeSpaceTapKeyboardHiding.append(textfield)
    }
    
}
