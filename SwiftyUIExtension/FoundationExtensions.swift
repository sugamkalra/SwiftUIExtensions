//
//  FoundationExtensions.swift
//  SwiftyUIExtension
//
//  Created by Sugam Kalra on 17/12/15.
//  Copyright © 2015 Sugam Kalra. All rights reserved.
//

import Foundation

/**
* Dictionary Extension
* Some useful functions added to Dictionary class
*
* @author Sugam
* @version 1.0
*/
extension Dictionary {
    
    /**
     Create url string from Dictionary
     
     - Returns: the url string
     */
    func toURLString() -> String {
        var urlString = ""
        
        // Iterate all key,value and form the url string
        for (key, value) in self {
            let keyEncoded = (key as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let valueEncoded = (value as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            urlString += ((urlString == "") ? "" : "&") + keyEncoded + "=" + valueEncoded
        }
        return urlString
    }
}

/**
* String Extension
* Some useful functions added to String class
*
* @author Sugam
* @version 1.1
*
* changes:
* 1.1:
* - new methods are added
*/
extension String {
    
    /**
    Get string without spaces at the end and at the start.
    
    - returns: trimmed string
    */
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
    Checks if string contains given substring
    
    - parameter substring:     the search string
    - parameter caseSensitive: flag: true - search is case sensitive, false - else
    
    - returns: true - if the string contains given substring, false - else
    */
    func contains(substring: String, caseSensitive: Bool = true) -> Bool {
        if let _ = self.rangeOfString(substring,
            options: caseSensitive ? NSStringCompareOptions(rawValue: 0) : .CaseInsensitiveSearch) {
                return true
        }
        return false
    }
    
    /**
    Shortcut method for stringByReplacingOccurrencesOfString
    
    - parameter target:     the string to replace
    - parameter withString: the string to add instead of target
    
    - returns: a result of the replacement
    */
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString,
            options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    /**
    Checks if the string is number
    
    - returns: true if the string presents number
    */
    func isNumber() -> Bool {
        let formatter = NSNumberFormatter()
        if let _ = formatter.numberFromString(self) {
            return true
        }
        return false
    }
    
    /**
    Checks if the string is positive number
    
    - returns: true if the string presents positive number
    */
    func isPositiveNumber() -> Bool {
        let formatter = NSNumberFormatter()
        if let number = formatter.numberFromString(self) {
            if number.doubleValue > 0 {
                return true
            }
        }
        return false
    }
    
    /**
    Get URL encoded string.
    
    - returns: URL encoded string
    */
    public func urlEncodedString() -> String {
        let set = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet;
        set.removeCharactersInString(":?&=@+/'");
        return self.stringByAddingPercentEncodingWithAllowedCharacters(set as NSCharacterSet)!
    }
    
    /**
    Get a localized string
    
    - returns: the localized string.
    */
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    /**
    Truncate string with given length
    
    - parameter length:   the length
    - parameter trailing: the  trailing
    
    - returns: truntacted string
    */
    func truncate(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    
    /**
    Encode current string with Base64 algorithm
    
    - returns: the encoded string
    */
    public func encodeBase64() -> String {
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64Encoded
        }
        return self
    }
}

/**
*  Helpful formatters
*/
struct NSDateFormatters {
    
    /// The formatter is used to parse and format dates for API
    static var dateParser: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss" // if hours are [0-23]
        f.locale = NSLocale(localeIdentifier: "GMT")
        return f
        }()
    /// the length of the dateFormat string above
    static var dateStringLength = 19
    
    /// The formatter is used to show dates in UI
    static var shortFormetter: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateStyle = .ShortStyle
        f.locale = NSLocale(localeIdentifier: "GMT")
        return f
        }()
}

/**
* Shortcut methods for NSDate
*
* @author Sugam
* @version 1.0
*/
extension NSDate {
        
    /**
     Parse full date string, e.g. 2014-11-17T19:39:12
     
     - parameter string: the date string
     
     - returns: date object or nil
     */
    class func parseFullDate(var string: String) -> NSDate? {
        struct Static {
            static var dateParser: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd HH:mm:ss" // if hours are [0-23]
                f.locale = NSLocale(localeIdentifier: "GMT")
                return f
            }()
            static var dateStringLength = 19
        }
        
        string = string.substringToIndex(string.startIndex.advancedBy(Static.dateStringLength))
        return Static.dateParser.dateFromString(string)
    }

    
    /**
    Format the date using NSDateFormatters.dateParser
    
    - returns: the date string
    */
    func formatFullDate() -> String {
        return NSDateFormatters.dateParser.stringFromDate(self)
    }
    
    /**
    Is given date is of the same week
    
    - returns: true - if this day relates to the same week, false - else
    */
    func isTheSameWeekAsForDate(testDate: NSDate) -> Bool {
        return testDate.getNextSunday().isAfter(self)
    }
    
    /**
    Get Sunday
    
    - returns: the next sunday
    */
    func getNextSunday() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday], fromDate: self)
        let sundayWeekDayNumber = 1
        if comp.weekday == sundayWeekDayNumber {
            return self.endOfDay()
        }
        else {
            comp.weekday = sundayWeekDayNumber
            let date = calendar.dateFromComponents(comp)!
            // adding one week because Sunday is the first day of the week and we need to handle it as the last
            return date.endOfDay().addDays(7)
        }
    }
    
    /**
    Add days to the date
    
    - parameter daysToAdd: the number of days to add
    
    - returns: changed date
    */
    func addDays(daysToAdd: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        components.day = daysToAdd
        
        let date = calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions())!
        return date
    }
    
    /**
    Get the next day start
    
    - returns: the date
    */
    func nextDayStart() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        components.day = 1
        
        let date = calendar.dateByAddingComponents(components, toDate: self.beginningOfDay(),
            options: NSCalendarOptions(rawValue: 0))!
        return date
    }
    
    /**
    Get NSDate that corresponds to the start of current day.
    
    - returns: the date
    */
    func beginningOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day],
            fromDate:self)
        
        return calendar.dateFromComponents(components)!
    }
    
    /**
    Get NSDate that corresponds to the end of current day.
    
    - returns: the date
    */
    func endOfDay() -> NSDate {
        var date = nextDayStart()
        date = date.dateByAddingTimeInterval(-1)
        return date
    }
    
    /**
    Check if current date is after the given date
    
    - parameter date: the date to check
    
    - returns: true - if current date is after
    */
    func isAfter(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedDescending
    }
    
    
    /**
     get yesterday date
     
     - returns: yesterday date
     */
    func yesterday() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: self, options: [])
        return yesterday!
    }
    
    
}


/**
 * Extenstion adds helpful methods to Int
 *
 * @author Sugam
 * @version 1.0
 */
extension Int {
    
    /**
     Get uniform random value between 0 and maxValue
     
     - parameter maxValue: the limit of the random values
     
     - returns: random Int
     */
    static func random(maxValue: UInt32) -> Int {
        return Int(arc4random_uniform(maxValue))
    }
}


/**
* Extenstion adds helpful methods to Float
*
* @author Sugam
* @version 1.0
*/
extension Float {
    
    /**
    Formats float value with 2 signs after ".", e.g. 1.234 -> "1.23"
    
    - returns: the string representation of the float
    */
    func toString() -> String {
        if isInteger() {
            return NSString.localizedStringWithFormat("%.0f", self) as String
        }
        return NSString.localizedStringWithFormat("%.2f", self) as String
    }
    
    /**
    Check if the value is integer
    
    - returns: true - if integer value, false - else
    */
    func isInteger() -> Bool {
        return  self == Float(Int(self))
    }

}