//
//  Day10.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 13/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day10 {
    static func partOne(input: String) -> Int {
        var number = input
        
        for _ in 0..<40 {
            number = getNext(number)
        }
        
        return number.characters.count
    }
    
    static func partTwo(input: String) -> Int {
        var number = input
        
        for _ in 0..<50 {
            number = getNext(number)
        }
        
        return number.characters.count
    }
    
    static func getNext(number: String) -> String {
        let digits = number.characters
        
        var result = ""
        var char = digits.first!
        var count = 1
        
        let digitsDropped = digits.dropFirst()
        
        for digit in digitsDropped {
            if char != digit {
                result += "\(count)\(char)"
                char = digit
                count = 1
            } else {
                count += 1
            }
        }
        
        result += "\(count)\(char)"
        
        return result
    }
}