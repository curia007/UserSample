//
//  UIViewController+Keyboard.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/18/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboardWhenTapped()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
