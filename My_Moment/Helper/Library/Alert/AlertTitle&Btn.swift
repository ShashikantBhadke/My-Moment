//
//  AlertTitle&Btn.swift
//  Shride_iOS
//
//  Created by Shashikant's_Macmini on 21/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//
import Foundation

extension Alert {
    
    /// Enum For Alert Controller Titles
    enum AlertTitle: String {
        case appName        = "My Moment!"
        case error          = "Error!"
        case warning        = "Warning!"
        case login          = "Login"
        case Success        = "Success!"
        case FileSelected   = "File Selected"
        case sorry          = "Sorry!"
        case OTPGenerated   = "OTP Send"
    }
    
    /// Enum For Alert Button Titles
    enum AlertButton: String {
        case Ok             = "OK"
        case Yes            = "Yes"
        case No             = "No"
        case Done           = "Done"
        case Cancel         = "Cancel"
        case Logout         = "Logout"
        case Continue       = "Continue"
        case MALE           = "Male"
        case FEMALE         = "Female"
        case OTHER          = "Other"
        case EDIT           = "Edit"
        case REMOVE         = "Remove"
        case SETTING        = "Setting"
        case Update         = "Update"
    }
        
} //Alert


