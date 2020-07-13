//
//  FirebaseHelper.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 10/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import Firebase
import Foundation

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? {
        return data?.string
    }
}
extension Data {
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}
