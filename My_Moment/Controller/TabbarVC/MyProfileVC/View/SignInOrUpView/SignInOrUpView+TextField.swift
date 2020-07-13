//
//  SignInOrUpView+TextField.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 08/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit

// MARK:- Extension For :- UITextFieldDelegate
extension SignInOrUpView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtfEmail:
            txtfPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }        
        return true
    }
    
    
    
} //extension

