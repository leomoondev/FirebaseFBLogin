//
//  TextInputTableView.swift
//  FirebaseFBLogin
//
//  Created by Hyung Jip Moon on 2017-03-24.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit

public class TextInputTableView: UITableViewCell {
    
    @IBOutlet weak var myTextField: UITextField!
    
    public func configure(text: String?, placeholder: String?) {
        
        myTextField.text = text
        myTextField.placeholder = placeholder
    }
    
}
