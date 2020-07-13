//
//  TabBarVC.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import Firebase

final class TabBarVC: UITabBarController {
    
    // MARK:- Outlets
    
    // MARK:- Variable
    var fbAuth: Auth?
    var user: User?
    var onUserAuthChange: ((Auth?, User?)->())?
    private var handle: AuthStateDidChangeListenerHandle?
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            signInListner(false)
        }
    }
    
    // MARK:- SetUpView
    func setUpView() {
        signInListner()
    }
    
    func signInListner(_ isAdd: Bool = true) {
        if isAdd {
            handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
                guard let self = self else { return }
                self.fbAuth = auth
                self.user = user
                self.onUserAuthChange?(auth, user)
            }
        } else {
            if handle != nil {
                Auth.auth().removeStateDidChangeListener(handle!)
            }
        }
    }
    
    // MARK:- Button Action
    
    // MARK:- Custom Methods
    
    // MARK:- ReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        debugPrint("⚠️🤦‍♂️⚠️ Receive Memory Warning on \(self) ⚠️🤦‍♂️⚠️")
    }
    
    // MARK:- Deinit
    deinit {
        debugPrint("🏹 Controller is removed from memory \(self) 🎯 🏆")
    }
    
} //class
