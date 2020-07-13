//
//  MyProfileVC.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import Firebase

final class MyProfileVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet private weak var viewLogin        : SignInOrUpView!
    @IBOutlet private weak var viewProfile      : UIView!
    @IBOutlet private weak var lblWelcomeName   : UILabel!
    @IBOutlet private weak var indicator        : UIActivityIndicatorView!
    
    // MARK:- Variable
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as? TabBarVC)?.onUserAuthChange = UserLogedIn(_:_:)
    }
    
    // MARK:- SetUpView
    private func setUpView() {
        let auth = (self.tabBarController as? TabBarVC)?.fbAuth
        let user = (self.tabBarController as? TabBarVC)?.user
        UserLogedIn(auth, user)
        
        viewLogin.onButtonClicked = onLoginCliced
        viewLogin.onFailure = onLoginFailed
    }
    
    // MARK:- Button Action
    @IBAction private func btnSignOutPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            Alert.show(.appName, error.localizedDescription)
        }
    }
    
    // MARK:- Custom Methods
    private func onLoginCliced() {
        indicator.startAnimating()
    }
    private func onLoginFailed() {
        indicator.stopAnimating()
    }
    private func UserLogedIn(_ auth: Auth?, _ user: User?) {
        indicator.stopAnimating()
        let strEmail = user?.email ?? ""
        lblWelcomeName.text = strEmail.isEmpty ? "" : "Welcome back! \n\(strEmail)"
        viewLogin.isHidden = !strEmail.isEmpty
        viewProfile.isHidden = strEmail.isEmpty
    }
    
    // MARK:- ReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        debugPrint("⚠️🤦‍♂️⚠️ Receive Memory Warning on \(self) ⚠️🤦‍♂️⚠️")
    }
    
    // MARK:- Deinit
    deinit {
        debugPrint("🏹 Controller is removed from memory \(self) 🎯 🏆")
    }
    
} //class
