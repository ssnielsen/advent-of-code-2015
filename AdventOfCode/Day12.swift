//
//  Day12.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 15/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day12 {
    static func partOne(input: String) -> Int {
        do {
            let re = try NSRegularExpression(pattern: "(-?\\d+)", options: [])
            
            let matches = re.matchesInString(input, options: [], range: NSRange.init(location: 0, length: input.characters.count))
            
            let numbers = matches.map { Int(input.substringWithRange(Range<String.Index>.init(start: input.startIndex.advancedBy($0.range.location), end: input.startIndex.advancedBy($0.range.location + $0.range.length))))! }
            
            return numbers.reduce(0, combine: +)
        } catch {
            return 0
        }
    }
    
    static func partTwo(input: String) -> Int {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(input.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments)
            
            return sumWithNoRed(json)
        } catch {
            return 0
        }
    }
    
    static func sumWithNoRed(object: AnyObject) -> Int {
        if let dict = object as? [String:AnyObject] {
            let containsRed = dict.values.contains { value in
                if let str = value as? String {
                    return str == "red"
                } else {
                    return false
                }
            }
            if containsRed {
                return 0
            } else {
                return dict.values.reduce(0) { $0 + sumWithNoRed($1) }
            }
        } else if let array = object as? [AnyObject] {
            return array.reduce(0) { $0 + sumWithNoRed($1) }
        } else if let integer = object as? Int {
            return integer
        }
        
        return 0
    }
}