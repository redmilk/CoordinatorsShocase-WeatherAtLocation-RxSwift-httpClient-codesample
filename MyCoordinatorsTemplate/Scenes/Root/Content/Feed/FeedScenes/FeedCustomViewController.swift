//
//  FeedCustomViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 02.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class FeedCustomViewController: NoStoryboardController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let red = UILabel()
        red.backgroundColor = .lightGray
        let black = UILabel()
        black.backgroundColor = .gray
        black.textColor = .white
        let purple = UILabel()
        purple.backgroundColor = .darkGray
        
        let textfield = UITextField()
        textfield.text = "Try textFIELD input keyboard hiding..."
        textfield.backgroundColor = .blue
        textfield.font = UIFont.systemFont(ofSize: 22.0)
        textfield.textColor = .white
        textfield.delegate = self
        
        let textfield2 = UITextField()
        textfield2.text = "Try textFIELD input keyboard hiding..."
        textfield2.backgroundColor = .systemBlue
        textfield2.font = UIFont.systemFont(ofSize: 22.0)
        textfield2.textColor = .white
        textfield2.delegate = self
        
        addStackedViews(views: [red, black, purple, textfield, textfield2])
        
        addTextSourceFieldToConvenienceKeyboardHidingList(textFields: [textfield, textfield2])
    }
    
}
