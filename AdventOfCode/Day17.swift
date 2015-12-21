//
//  Day17.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 20/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day17 {
    static let eggnog = 150
    
    static func partOne(input: String) -> Int {
        let containers = Util.splitLines(input).map { Int($0)! }
        let combinations = findCombinations(containers, left: 150)
        return combinations.count
    }
    
    static func partTwo(input: String) -> Int {
        let containers = Util.splitLines(input).map { Int($0)! }
        let combinations = findCombinations(containers, left: 150)
        let minContainerAmount = combinations.map { $0.count }.minElement()!
        return combinations.filter { $0.count == minContainerAmount }.count
    }
    
    static func findCombinations(containers: [Int], left: Int) -> [[Int]] {
        if left <= 0 {
            return []
        }
        if containers.count == 1 {
            if containers.first! == left {
                return [containers]
            } else {
                return []
            }
        } else {
            var allCombinations = [[Int]]()
            
            for (index, container) in containers.enumerate() {
                if container == left {
                    allCombinations += [[container]]
                } else if container < left {
                    let containersLeft = Array(containers[index+1 ..< containers.count])
                    let nextCombinations = findCombinations(containersLeft, left: left - container)
                    allCombinations += nextCombinations.map { (var comb) in
                        comb.append(container)
                        return comb
                    }
                    
                }
            }
            
            return allCombinations
        }
    }
}