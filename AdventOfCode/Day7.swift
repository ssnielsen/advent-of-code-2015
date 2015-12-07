//
//  Day7.swift
//  AdventOfCode
//
//  Created by Søren Nielsen on 07/12/2015.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day7 {
    enum Action {
        case Assign(Int,String)
        case And(String,String,String)
        case Or(String,String,String)
        case Not(String,String)
        case LShift(String,Int,String)
        case RShift(String,Int,String)
    }
    
    func partOne(input: String) -> Int {
        var state = [String:Int]()
        
        parse(input).forEach { action in
            switch action {
                
            }
        }
    }
    
    func parse(input: String) -> [Action] {
        do {
            let assignPattern = "(\\d+) -> (\\w)"
            let assignRe = try NSRegularExpression(pattern: assignPattern, options: [])
            
            let andPattern = "(\\w) AND (\\w) -> (\\w)"
            let andRe = try NSRegularExpression(pattern: andPattern, options: [])
            
            let orPattern = "(\\w) OR (\\w) -> (\\w)"
            let orRe = try NSRegularExpression(pattern: orPattern, options: [])
            
            let lShiftPattern = "(\\w) LSHIFT (\\d+) -> (\\w)"
            let lShiftRe = try NSRegularExpression(pattern: lShiftPattern, options: [])
            
            let rShiftPattern = "(\\w) RSHIFT (\\d+) -> (\\w)"
            let rShiftRe = try NSRegularExpression(pattern: rShiftPattern, options: [])
            
            let notPattern = "NOT (\\w) -> (\\w)"
            let notRe = try NSRegularExpression(pattern: lShiftPattern, options: [])
        
            return Util.splitLines(input).map { line in
                if line.containsString("AND") {
                    let matches = andRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let lhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let rhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                    let wire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                    
                    return Action.And(lhs, rhs, wire)
                } else if line.containsString("OR") {
                        let matches = orRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                        let lhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                        let rhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                        let wire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                        
                        return Action.And(lhs, rhs, wire)
                }
            }
        } catch {
            print("Parsing failed")
        }
    }
    
}