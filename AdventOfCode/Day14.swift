//
//  Day14.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 15/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day14 {
    
    static func partOne(input: String) -> Int {
        var deers = parseInput(input)
        
        for _ in 0..<2503 {
            deers = deers.map { deer in
                var newDeer = deer
                switch deer.state {
                case .Flying(let left):
                    newDeer.distance += deer.speed
                    if left == 1 {
                        newDeer.state = .Resting(deer.restTime)
                    } else {
                        newDeer.state = .Flying(left - 1)
                    }
                case .Resting(let left):
                    if left == 1 {
                        newDeer.state = .Flying(deer.flyTime)
                    } else {
                        newDeer.state = .Resting(left - 1)
                    }
                }
                return newDeer
            }
        }
        
        return deers.map { $0.distance }.maxElement()!
    }
    
    static func partTwo(input: String) -> Int {
        
        var deers = parseInput(input)
        
        for _ in 0..<2503 {
            deers = deers.map { deer in
                var newDeer = deer
                switch deer.state {
                case .Flying(let left):
                    newDeer.distance += deer.speed
                    if left == 1 {
                        newDeer.state = .Resting(deer.restTime)
                    } else {
                        newDeer.state = .Flying(left - 1)
                    }
                case .Resting(let left):
                    if left == 1 {
                        newDeer.state = .Flying(deer.flyTime)
                    } else {
                        newDeer.state = .Resting(left - 1)
                    }
                }
                return newDeer
            }
            
            let maxDistance = deers.map { $0.distance }.maxElement()
            deers = deers.map { deer in
                if deer.distance == maxDistance {
                    var newDeer = deer
                    newDeer.points += 1
                    return newDeer
                }
                return deer
            }
        }
        
        return deers.map { $0.points }.maxElement()!
    }
    
    static func parseInput(input: String) -> [Deer] {
        var re: NSRegularExpression?
        
        do {
            re = try NSRegularExpression(pattern: "([A-Za-z]+)\\D+(\\d+)\\D+(\\d+)\\D+(\\d+)\\D+\\.", options: [])
        } catch { }
        
        return Util.splitLines(input).map { line in
            let matches = re?.matchesInString(line, options: [], range: NSRange.init(location: 0, length: line.characters.count))
            let name = (line as NSString).substringWithRange(matches![0].rangeAtIndex(1))
            let speed = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(2)))!
            let flyTime = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(3)))!
            let restTime = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(4)))!
            
            return Deer(name: name, speed: speed, flyTime: flyTime, restTime: restTime, distance: 0, points: 0, state: .Flying(flyTime))
        }
    }
    
    struct Deer {
        let name: String
        let speed: Int
        let flyTime: Int
        let restTime: Int
        var distance: Int
        var points: Int
        var state: State
    }
    
    enum State {
        case Flying(Int)
        case Resting(Int)
    }
}