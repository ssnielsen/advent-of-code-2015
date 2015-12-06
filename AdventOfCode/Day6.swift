//
//  Day6.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day6 {
    enum Action {
        case Off, On, Toggle
        
        func perform(oldValue: Bool) -> Bool {
            switch self {
                case .Off: return false
                case .On: return true
                case .Toggle: return !oldValue
            }
        }
    }
    
    static func partOne(input: String) -> Int {
        let size = 1000
        var grid = Array.init(count: size, repeatedValue: Array.init(count: size, repeatedValue: false))
        
        parseInput(input).forEach { instruction in
            print(instruction)
            for x in instruction.from.x...instruction.to.x {
                for y in instruction.from.y...instruction.to.y {
                    grid[x][y] = instruction.action.perform(grid[x][y])
                }
            }
        }
        
        return grid.reduce(0) { (res, line) in
            return res + line.reduce(0) { (res, light) in
                return res + (light ? 1 : 0)
            }
        }
    }
    
    static func parseInput(input: String) -> [(action: Action, from: (x:Int,y:Int), to: (x:Int,y:Int))] {
        do {
            let pattern = "(\\d+),(\\d+) through (\\d+),(\\d+)"
            let re = try NSRegularExpression(pattern: pattern, options: [])
        
            return Util.splitLines(input).map { line in
                let matches = re.matchesInString(line, options: [], range: NSRange(location: 0, length: line.characters.count))
                
                let fromX = Int((line as NSString).substringWithRange(matches[0].rangeAtIndex(1)))!
                let fromY = Int((line as NSString).substringWithRange(matches[0].rangeAtIndex(2)))!
                let toX = Int((line as NSString).substringWithRange(matches[0].rangeAtIndex(3)))!
                let toY = Int((line as NSString).substringWithRange(matches[0].rangeAtIndex(4)))!

                var action: Action?
                
                if line.hasPrefix("turn on") {
                    action = .On
                } else if line.hasPrefix("turn off") {
                    action = .Off
                } else if line.hasPrefix("toggle") {
                    action = .Toggle
                }
                
                return (action: action ?? .Off, from: (x: fromX, y: fromY), to: (x: toX, y: toY))
            }
        } catch {
            print("Parse error")
            return []
        }
    }
}