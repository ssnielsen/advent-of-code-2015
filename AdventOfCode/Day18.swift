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
    
    static func partOne(input: String) -> Int {
        var state = parseInput(input)
        corners.forEach { (x, y) in
            state[x][y] = 1
        }
        
        for _ in 1...100 {
            state = nextState(state)
        }
        
        return state.reduce(0, combine: { (res, line) in
            return res + line.reduce(0, combine: +)
        })
    }
    
    static func neighbors(state: [[Int]], x: Int, y: Int) -> Int {
        let around = [(-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)]
        let coords = around.map { (x: $0.0 + x, y: $0.1 + y) }
        let filtered = coords.filter { (x, y) in
            let xBound = x >= 0 && x < size
            let yBound = y >= 0 && y < size
            return xBound && yBound
        }
        return filtered
            .filter { (x, y) in state[x][y] == 1 }
            .count
    }
    
    static func nextState(state: [[Int]]) -> [[Int]] {
        return state.mapWithIndex { (x, line) in
            return line.mapWithIndex { (y, light) in
                return nextState(state, x: x, y: y)
            }
        }
    }
    
    static func nextState(state: [[Int]], x: Int, y: Int) -> Int {
        let isCorner = corners.contains { $0 == x && $1 == y }
        if isCorner {
            return 1
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