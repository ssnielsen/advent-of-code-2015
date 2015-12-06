//
//  Day2.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day2 {
    static func partOne(input: String) -> Int {
        return Util.splitLines(input).reduce(0) { (res, line) in
            let sides = line.characters.split("x")
            let l = Int(String(sides[0]))!
            let w = Int(String(sides[1]))!
            let h = Int(String(sides[2]))!
            return res + 2*l*w + 2*w*h + 2*h*l + min(l*w, w*h, h*l)
        }
    }
    
    static func partTwo(input: String) -> Int {
        return Util.splitLines(input).reduce(0) { (res, line) in
            let sides = line.characters.split("x")
            let l = Int(String(sides[0]))!
            let w = Int(String(sides[1]))!
            let h = Int(String(sides[2]))!
            return res + l+l + w+w + h+h - 2*max(l, w, h) + l * w * h
        }
    }
}