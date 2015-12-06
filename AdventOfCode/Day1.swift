//
//  Day1.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day1 {
    static func partOne(input: String) -> Int {
        return input.characters.reduce(0) { (res, char) in
            switch char {
                case "(": return res + 1
                case ")": return res - 1
                default: return res
            }
        }
    }
    
    static func partTwo(input: String) -> Int {
        return input.characters.reduce((result: 0, foundBasement: false, position: 0)) { (res, char) in
            if res.foundBasement {
                return res
            }
            switch char {
                case "(": let newFloor = res.result + 1; return (result: newFloor, foundBasement: newFloor == -1, position: res.position + 1)
                case ")": let newFloor = res.result - 1; return (result: newFloor, foundBasement: newFloor == -1, position: res.position + 1)
                default: return res
            }
        }.position
    }
}