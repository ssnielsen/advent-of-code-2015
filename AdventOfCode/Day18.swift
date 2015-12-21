//
//  Day18.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 21/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day18 {
    static let size = 100
    
    static let corners = [(0,0), (0,size-1), (size-1,0), (size-1,size-1)]
    
    static let cornersAlwaysOn: (Int, Int) -> Int? = { (xIn,yIn) in
        let isCorner = corners.contains { (x, y) in
            return xIn == x && yIn == y
        }
        return isCorner ? 1 : nil
    }
    
    static func partOne(input: String) -> Int {
        var state = parseInput(input)
        
        for _ in 1...100 {
            state = nextState(state)
        }
        
        return state.reduce(0, combine: { (res, line) in
            return res + line.reduce(0, combine: +)
        })
    }
    
    static func partTwo(input: String) -> Int {
        var state = parseInput(input)
        corners.forEach { (x, y) in
            state[x][y] = 1
        }
        
        for _ in 1...100 {
            state = nextState(state, overrules: cornersAlwaysOn)
        }
        
        return state.reduce(0, combine: { (res, line) in
            return res + line.reduce(0, combine: +)
        })
    }
    
    static func neighbors(state: [[Int]], x: Int, y: Int) -> Int {
        let around = [(-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)]
        let coords = around.map { (x: $0.0 + x, y: $0.1 + y) }
        return coords
            .filter { (x, y) in
                return x >= 0 && x < size && y >= 0 && y < size && state[x][y] == 1
            }
            .count
    }
    
    static func nextState(state: [[Int]], overrules: ((Int, Int) -> Int?)? = nil) -> [[Int]] {
        return state.mapWithIndex { (x, line) in
            return line.mapWithIndex { (y, light) in
                return nextState(state, x: x, y: y, overrules: overrules)
            }
        }
    }
    
    static func nextState(state: [[Int]], x: Int, y: Int, overrules: ((Int, Int) -> Int?)? = nil) -> Int {
        if let overruled = overrules?(x, y) {
            return overruled
        }
        switch (neighbors(state, x: x, y: y), state[x][y]) {
        case (2, 1), (3, 1): return 1
        case (3, 0): return 1
        case _: return 0
        }
    }
    
    static func parseInput(input: String) -> [[Int]] {
        return Util.splitLines(input).map { line in
            return line.characters.map { char in
                return char == Character("#") ? 1 : 0
            }
        }
    }
}

extension Array {
    public func mapWithIndex<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}