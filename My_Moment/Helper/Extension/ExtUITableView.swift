//
//  UITableView+GUL.swift
//  GUL
//
//  Created by Shashikant's Mac on 9/17/19.
//  Copyright © 2019 redbytes. All rights reserved.
//

import UIKit

// MARK:- Extension for - UITableView
extension UITableView {
    
    // Add and remove Lable on count with title
    func tableViewEmptyLabel(_ count: Int, _ clr: UIColor = UIColor.lightGray, _ fontSize: CGFloat = 14, _ strText: String = "No data available") {
        if count > 0{
            self.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            noDataLabel.font            = UIFont.systemFont(ofSize: fontSize)
            noDataLabel.text            = strText
            noDataLabel.numberOfLines   = 0
            noDataLabel.textColor       = clr
            noDataLabel.textAlignment   = .center
            self.backgroundView         = noDataLabel
        }
    }
    
} //extension
