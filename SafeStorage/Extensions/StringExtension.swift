//
//  StringExtension.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/12/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

extension String {
    public var length: Int { return self.count }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Get standard formatted phone number from string
    ///
    /// - Returns: Standard formatted phone number
    func formatPhone(with format: String = "+7 %@-%@-%@-%@") -> String {
        var digits = self.onlyDigits()
        if digits.length == 11 {
            digits = digits.substr(1)
        }
        if digits.length == 10 {
            return String(format: format, digits.substr(0, 3), digits.substr(3, 6), digits.substr(6, 8), digits.substr(8, 10))
        }
        return digits
    }
    
    /// Get string with only digits
    ///
    /// - Returns: String with digits only
    func onlyDigits() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    /// Substring method
    ///
    /// - Parameters:
    ///   - lower: lower bound
    ///   - upper: upper bound (exclusive)
    /// - Returns: substring value
    func substr(_ lower: Int, _ upper: Int? = nil) -> String {
        // guard against negative lower bound
        var low = max(0, lower)
        // guard against lower bound overflown
        low = min(count, low)
        // guard against nil or overflown upper bound
        var up = min(count, upper ?? count)
        // guard against upper < lower case
        up = max(up, low)
        
        return self[Range(uncheckedBounds: (low, up))]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
