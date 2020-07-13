//
//  SignInOrUpView.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 08/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import Firebase

final class SignInOrUpView: UIView {
    
    // MARK:- Outlets
    @IBOutlet internal weak var txtfEmail       : UITextField!
    @IBOutlet internal weak var txtfPassword    : UITextField!
    
    // MARK:- Variables
    var onButtonClicked: (()->())?
    var onFailure: (()->())?
    
    // MARK:- Default Methods
    override func awakeFromNib() {
        txtfEmail.delegate = self
        txtfPassword.delegate = self
        
//        txtfEmail.text = "shashibhadke22@gmail.com"
//        txtfPassword.text = "123456"
    }
    
    // MARK:- Custom Methods
    private func checkValidations() ->Bool {
        self.endEditing(true)
        if (txtfEmail.text ?? "").isEmpty {
            Alert.show(.appName, .Email)
            return false
        }
        if !(txtfEmail.text ?? "").isValidEmail {
            Alert.show(.appName, .InvalidEmail)
            return false
        }
        if (txtfPassword.text ?? "").count < 6 {
            Alert.show(.appName, .PasswordLength)
            return false
        }
        return true
    }
    
    private func signUpCalled() {
        guard checkValidations() else { return }
        Auth.auth().createUser(withEmail: txtfEmail.text ?? "", password: txtfPassword.text ?? "") { authResult, error in
            if let objSuccess = authResult {
                debugPrint(objSuccess)
            } else {
                self.onFailure?()
                Alert.show(.appName, error?.localizedDescription ?? Alert.AlertMessage.Oops.rawValue)
            }
        }
    }
    private func signInCalled() {
        guard checkValidations() else { return }
        Auth.auth().signIn(withEmail: txtfEmail.text ?? "", password: txtfPassword.text ?? "") { authResult, error in
            if let objSuccess = authResult {
                debugPrint(objSuccess)
            } else {
                self.onFailure?()
                Alert.show(.appName, error?.localizedDescription ?? Alert.AlertMessage.Oops.rawValue)
            }
        }
    }
    
    // MARK:- Button Methods
    @IBAction private func btnSignInPressed() {
        signInCalled()
        onButtonClicked?()
    }
    
    @IBAction private func btnSignUpPressed() {
        signUpCalled()
        onButtonClicked?()
    }
    
} //class
