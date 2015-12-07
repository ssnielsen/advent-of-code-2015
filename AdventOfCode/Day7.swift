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
        case Assign(UInt16)
        case VarAssign(String)
        case And(Wire,Wire)
        case Or(Wire,Wire)
        case Not(String)
        case LShift(String,UInt16)
        case RShift(String,UInt16)
    }
    
    enum Wire {
        case Value(UInt16)
        case Wire(String)
    }
    
    static var actions = [String:Action]()
    static var cache = [String:UInt16]()
    
    static func partOne(input: String) -> Int {
        actions = parse(input)
        
        return Int(recursive("a"))
    }
    
    static func partTwo(input: String) -> Int {
        let aValue = partOne(input)
        
        cache = [:]
        
        actions["b"] = .Assign(UInt16(aValue))
        
        return Int(recursive("a"))
    }
    
    static func recursive(wire: String) -> UInt16 {
        if let cached = cache[wire] {
            return cached
        }
        
        if let action = actions[wire] {
            let result: UInt16
        
            switch action {
            case let .Assign(value):
                result = value
            case let .VarAssign(fromWire):
                result = recursive(fromWire)
            case let .And(.Value(lVal), .Value(rVal)):
                result = lVal & rVal
            case let .And(.Wire(lWire), .Value(rVal)):
                result = recursive(lWire) & rVal
            case let .And(.Value(lVal), .Wire(rWire)):
                result = lVal & recursive(rWire)
            case let .And(.Wire(lWire), .Wire(rWire)):
                result = recursive(lWire) & recursive(rWire)
            case let .Or(.Value(lVal), .Value(rVal)):
                result = lVal | rVal
            case let .Or(.Wire(lWire), .Value(rVal)):
                result = recursive(lWire) | rVal
            case let .Or(.Value(lVal), .Wire(rWire)):
                result = lVal | recursive(rWire)
            case let .Or(.Wire(lWire), .Wire(rWire)):
                result = recursive(lWire) | recursive(rWire)
            case let .Not(fromWire):
                result = ~recursive(fromWire)
            case let .LShift(fromWire, value):
                result = recursive(fromWire) << value
            case let .RShift(fromWire, value):
                result = recursive(fromWire) >> value
            }
            
            cache[wire] = result
            
            return result
        } else {
            print("Could not find action for wire \(wire)")
            return 0
        }
    }
    
    static func parse(input: String) -> [String:Action] {
        do {
            let assignPattern = "(\\d+) -> (\\w+)"
            let assignRe = try NSRegularExpression(pattern: assignPattern, options: [])
            
            let varAssignPattern = "(\\w+) -> (\\w+)"
            let varAssignRe = try NSRegularExpression(pattern: varAssignPattern, options: [])
            
            let andPattern = "(\\w+) AND (\\w+) -> (\\w+)"
            let andRe = try NSRegularExpression(pattern: andPattern, options: [])
            
            let orPattern = "(\\w+) OR (\\w+) -> (\\w+)"
            let orRe = try NSRegularExpression(pattern: orPattern, options: [])
            
            let lShiftPattern = "(\\w+) LSHIFT (\\d+) -> (\\w+)"
            let lShiftRe = try NSRegularExpression(pattern: lShiftPattern, options: [])
            
            let rShiftPattern = "(\\w+) RSHIFT (\\d+) -> (\\w+)"
            let rShiftRe = try NSRegularExpression(pattern: rShiftPattern, options: [])
            
            let notPattern = "NOT (\\w+) -> (\\w+)"
            let notRe = try NSRegularExpression(pattern: notPattern, options: [])
            
            var result = [String:Action]()
            
            Util.splitLines(input).forEach { line in
                if line.containsString("AND") {
                    let matches = andRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let lhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let rhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                    let wire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(3))
                    
                    let lhsWire = (UInt16(lhs) != nil) ? Wire.Value(UInt16(lhs)!) : Wire.Wire(lhs)
                    let rhsWire = (UInt16(rhs) != nil) ? Wire.Value(UInt16(rhs)!) : Wire.Wire(rhs)
                    
                    result[wire] = Action.And(lhsWire, rhsWire)
                } else if line.containsString("OR") {
                    let matches = orRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let lhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let rhs = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                    let wire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(3))
                    
                    let lhsWire = (UInt16(lhs) != nil) ? Wire.Value(UInt16(lhs)!) : Wire.Wire(lhs)
                    let rhsWire = (UInt16(rhs) != nil) ? Wire.Value(UInt16(rhs)!) : Wire.Wire(rhs)
                    
                    result[wire] = Action.Or(lhsWire, rhsWire)
                } else if line.containsString("LSHIFT") {
                    let matches = lShiftRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let fromWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let value = UInt16((line as NSString).substringWithRange(matches[0].rangeAtIndex(2)))!
                    let toWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(3))
                    
                    result[toWire] = Action.LShift(fromWire, value)
                } else if line.containsString("RSHIFT") {
                    let matches = rShiftRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let fromWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let value = UInt16((line as NSString).substringWithRange(matches[0].rangeAtIndex(2)))!
                    let toWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(3))
                    
                    result[toWire] = Action.RShift(fromWire, value)
                } else if line.containsString("NOT") {
                    let matches = notRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    let fromWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                    let toWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                    
                    result[toWire] = Action.Not(fromWire)
                } else {
                    let matches = assignRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                    
                    if matches.count > 0 {
                        let value = UInt16((line as NSString).substringWithRange(matches[0].rangeAtIndex(1)))!
                        let wire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                        
                        result[wire] = Action.Assign(value)
                    } else {
                        let matches = varAssignRe.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                        let fromWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                        let toWire = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                        
                        result[toWire] = Action.VarAssign(fromWire)
                    }
                }
            }
            
            return result
        } catch {
            print("Parsing failed")
            return [:]
        }
    }
    
}