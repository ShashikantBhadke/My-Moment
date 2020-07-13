//
//  Loader.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 25/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// MARK:- Configuring NVActivityIndicatorView
extension  UIViewController: NVActivityIndicatorViewable {
    
    func showLoader() {
        DispatchQueue.main.async {
            self.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
} //UIViewController
