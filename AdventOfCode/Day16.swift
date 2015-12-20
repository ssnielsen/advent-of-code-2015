//
//  Day16.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 18/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day16 {
    static let known = [
        "children": 3,
        "cats": 7,
        "samoyeds": 2,
        "pomeranians": 3,
        "akitas": 0,
        "vizslas": 0,
        "goldfish": 5,
        "trees": 3,
        "cars": 2,
        "perfumes": 1
    ]
    
    static func partOne(input: String) -> Int {
        return parseInput(input).filter { (num, aunt) in
            for (attr, val) in aunt {
                if known[attr] != val {
                    return false
                }
            }
            return true
        }.first!.0
    }
    
    static func partTwo(input: String) -> Int {
        let a = parseInput(input).filter { (num, aunt) in
            return aunt.filter { (attr, val) in
                switch attr {
                case "cats", "trees":
                    return known[attr] < val
                case "pomeranians", "goldfish":
                    return known[attr] > val
                default:
                    return known[attr] == val
                }
            }.count == 3
        }
        return a.first!.0
    }
    
    static func parseInput(input: String) -> [(Int, [String:Int])] {
        let pattern = "([a-z]+):\\s(\\d+)"
        var re: NSRegularExpression?
        
        do {
            re = try NSRegularExpression(pattern: pattern, options: [])
        } catch { }
        
        var number = 1
        
        return Util.splitLines(input).map { line in
            let matches = re?.matchesInString(line, options: [], range: NSRange.init(location: 0, length: line.characters.count))
            
            var aunt = [String:Int]()

            for match in matches! {
                let attribute = (line as NSString).substringWithRange(match.rangeAtIndex(1))
                let value = Int((line as NSString).substringWithRange(match.rangeAtIndex(2)))!
                
                aunt[attribute] = value
            }
            let returnValue = (number, aunt)
            number += 1
            return returnValue
        }
    }
}