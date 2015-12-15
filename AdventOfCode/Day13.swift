//
//  Day13.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 15/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day13 {
    static var data = [String:[String:Int]]()
    
    static func partOne(input: String) -> Int {
        parseInput(input)
        
        let sittings = Day9.allPermutations(Array(data.keys))
        
        return findMaxHappiness(sittings)
    }
    
    static func partTwo(input: String) -> Int {
        parseInput(input)
        
        data["myself"] = [:]
        for person in data.keys {
            data["myself"]?[person] = 0
            data[person]?["myself"] = 0
        }
        
        let sittings = Day9.allPermutations(Array(data.keys))
        
        return findMaxHappiness(sittings)
    }
    
    static func findMaxHappiness(sittings: [[String]]) -> Int {
        var maxHappiness = 0
        
        for i in 0..<sittings.count {
            let sittingHappiness = calculateSitting(sittings[i])
            maxHappiness = max(maxHappiness, sittingHappiness)
        }
        
        return maxHappiness
    }
    
    static func calculateSitting(sitting: [String]) -> Int {
        var happiness = 0
        
        for i in 0..<sitting.count-1 {
            happiness += (data[sitting[i]]?[sitting[i+1]])! + (data[sitting[i+1]]?[sitting[i]])!
        }
        
        return happiness + (data[sitting.first!]?[sitting.last!])! + (data[sitting.last!]?[sitting.first!])!
    }
    
    static func parseInput(input: String) {
        var re: NSRegularExpression?
        
        do {
            re = try NSRegularExpression(pattern: "([A-Za-z]+)\\swould\\s(gain|lose)\\s(\\d+)\\shappiness\\sunits\\sby\\ssitting\\snext\\sto\\s([A-Za-z]+)", options: [])
        } catch { }
        
        Util.splitLines(input).forEach { line in
            let matches = re?.matchesInString(line, options: [], range: NSRange.init(location: 0, length: line.characters.count))
            let person = (line as NSString).substringWithRange(matches![0].rangeAtIndex(1))
            let posNeg = (line as NSString).substringWithRange(matches![0].rangeAtIndex(2))
            let change = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(3)))!
            let neighbour = (line as NSString).substringWithRange(matches![0].rangeAtIndex(4))
            
            if data[person] == nil {
                data[person] = [:]
            }
            
            data[person]?[neighbour] = posNeg == "lose" ? -change : change
        }
    }
}