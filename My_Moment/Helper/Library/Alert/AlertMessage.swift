//
//  AlertMessage.swift
//  Shride_iOS
//
//  Created by Shashikant's_Macmini on 21/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//

import UIKit

extension Alert {
    
    /// Enum For Alert Message
    enum AlertMessage: String {
        case Oops               = "Oops something went. Please try again!"
        case InvalidEmail       = "Please enter valid email."
        case Email              = "Please enter email."
        case PasswordLength     = "Please enter minimum 6 characters password."
    }
    
} //Alert


