//
//  String+GUL.swift
//  GUL
//
//  Created by Shashikant's Mac on 9/17/19.
//  Copyright © 2019 redbytes. All rights reserved.
//

import UIKit

// MARK:- Extension For - String
extension String {
    
    var isIPv4: Bool {
        var sin = sockaddr_in()
        return self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1
    }
    
    var isIPv6: Bool {
        var sin6 = sockaddr_in6()
        return self.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1
    }
    
    var isValidIPAddress: Bool {
        return self.isIPv6 || self.isIPv4
    }
    
    var trimText: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isValidUserName: Bool {
        let RegEx = "^\\w{7,18}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isAlphanumeric: Bool {
        return range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isAlphaOnly: Bool{
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: self)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
    
    var isNumeric: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var isValidPinCode: Bool {
        return !self.isEmpty && self.isNumeric && self.count == 6
    }
    
    public func firstCharacters(separator: String = "") -> String {
        var str = ""
        let acronyms = separator.components(separatedBy: " ")
        guard acronyms.count > 1 else { return separator }
        acronyms.forEach { (str1) in
            if let char1 = str1.first {
                str.append(char1)
            }
        }
        return str.isEmpty ? separator : str
    }
    
    func camelCaseToWords() -> String {
        
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                return ($0 + " " + String($1))
            } else {
                return $0 + String($1)
            }
        }
    }
    
    func addSpacesInCapitalLetters() -> String{
        var string = self
        
        //indexOffset is needed because each time replaceSubrange is called, the resulting count is incremented by one (owing to the fact that a space is added to every capitalised letter)
        var indexOffset = 0
        for (index, character) in string.enumerated(){
            let stringCharacter = String(character)
            
            //Evaluates to true if the character is a capital letter
            if stringCharacter.lowercased() != stringCharacter{
                guard index != 0 else { continue } //"ILoveSwift" should not turn into " I Love Swift"
                let stringIndex = string.index(string.startIndex, offsetBy: index + indexOffset)
                let endStringIndex = string.index(string.startIndex, offsetBy: index + 1 + indexOffset)
                let range = stringIndex..<endStringIndex
                indexOffset += 1
                string.replaceSubrange(range, with: " \(stringCharacter)")
            }
        }
        return string
    }
    
    /*
     Check character count in given string/text is valid or not
     We can modify this by according to need ==, >=, <= etc
     */
    var isValidCharacterCount: Bool {
        return (self.trimmingCharacters(in: .whitespaces).isEmpty) ? false : (self.count == 10) ? true : false
    }
    
    //Using this function user can send valid character count to check
    func isValidCharacterCount(validCount: Int) -> Bool {
        return (self.trimmingCharacters(in: .whitespaces).isEmpty) ? false : (self.count == validCount) ? true : false
    }
    
    /*
     Trim your string from whitespace characters and check if it's empty
     If No text in textbox returns 'false' else 'true'
     */
    var isEmptyField: Bool {
        return (self.trimmingCharacters(in: .whitespaces).isEmpty) ? false : true
    }
    
    // Replace spaces with %20 for url string
    func replacingSpacesWithPercentTwenty() -> String {
        return replacingOccurrences(of: " ", with: "%20")
    }
    
    //Calculate time ago from given date
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool = true) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    /// Height of TextView
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Encode And Decode Emoji Code To string and vise-varsa
    func decode() -> String {
        let data = self.data(using: .utf8) ?? Data()
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    static func getStringFromDate(formate: String, date: Date)-> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formate
        return dateformatter.string(from: date)
    }
    
    static func getDateStringWithTodaysOption(_ strdate: String?)->String {
        guard let strdate = strdate else { return "" }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateformatter.date(from: strdate)
        guard let date1 = date else { return "" }
        var strReturnDate = ""
        dateformatter.dateFormat = "yyyy-MM-dd"
        if dateformatter.string(from: Date()) == dateformatter.string(from: date1) {
            dateformatter.dateFormat = "h:mm a"
            strReturnDate = "Today " + dateformatter.string(from: date1)
        } else {
            dateformatter.dateFormat = "MMM d, yyyy, h:mm a"
            strReturnDate = dateformatter.string(from: date1)
        }
        return strReturnDate
    }
    
    static func getDateStringWithDifferentFormat(_ strdate: String?)->String {
        guard let strdate = strdate else { return "" }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateformatter.date(from: strdate)
        guard let date1 = date else { return "" }
        dateformatter.dateFormat = "MMM d, yyyy, h:mm a"
        return dateformatter.string(from: date1)
    }
    
    static func getTimeString(interval: TimeInterval)->String {
        //let hour = Int(time) / 3600
        let minute = Int(interval) / 60 % 60
        let second = Int(interval) % 60
        
        return String(format: "%02i:%02i", minute, second)
    }
    
    static func getTimeString_Hours(_ time: Int) -> String {
        let hour = time / 3600
        return String(format: "%02i hrs", hour)
    }
    
    static func getTimeHMString(_ time: Int)->String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        //        let second = Int(interval) % 60
        if hour > 1 {
            return String(format: "%02ihrs %02imin", hour, minute)
        } else {
            return String(format: "%02ihr %02imin", hour, minute)
        }
    }
}//extension
