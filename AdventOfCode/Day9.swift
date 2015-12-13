//
//  Day9.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 13/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day9 {
    static func partOne(input: String) -> Int {
        var distances = processData(processInput(input))
        
        let permutations = allPermutations(Array(distances.keys))
        
        var shortest = Int.max
        
        for permutation in permutations {
            var distance = 0
            for i in 0..<permutation.count-1 {
                distance += (distances[permutation[i]]?[permutation[i+1]])!
            }
            shortest = min(shortest, distance)
        }
        
        return shortest
    }
    
    static func partTwo(input: String) -> Int {
        var distances = processData(processInput(input))
        
        let permutations = allPermutations(Array(distances.keys))
        
        var longest = Int.min
        
        for permutation in permutations {
            var distance = 0
            for i in 0..<permutation.count-1 {
                distance += (distances[permutation[i]]?[permutation[i+1]])!
            }
            longest = max(longest, distance)
        }
        
        return longest
    }
    
    // Get all permutations
    static func allPermutations(input: [String]) -> [[String]] {
        var permutations = [[String]]()
        
        func helper(start: [String], rests: [String]) {
            if rests.isEmpty {
                permutations.append(start)
            } else {
                for rest in rests {
                    var restsCopy = rests
                    restsCopy.removeAtIndex(restsCopy.indexOf(rest)!)
                    helper(start + [rest], rests: restsCopy)
                }
            }
        }
        
        helper([], rests: input)
        
        return permutations
    }
    
    static func processInput(input: String) -> [(String, String, Int)] {
        do {
            let re = try NSRegularExpression(pattern: "([A-Za-z]+)\\sto\\s([A-Za-z]+)\\s\\=\\s(\\d+)", options: [])
            
            return Util.splitLines(input).map { line in
                let matches = re.matchesInString(line, options: [], range: NSRange.init(location: 0, length: line.characters.count))
                let from = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                let to = (line as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                let distance = Int((line as NSString).substringWithRange(matches[0].rangeAtIndex(3)))!
                return (from, to, distance)
            }
        } catch {
            print("error")
            return []
        }
    }
    
    static func processData(data: [(String, String, Int)]) -> [String:[String:Int]] {
        var distances = [String:[String:Int]]()
        
        data.forEach {
            if distances[$0.0] == nil {
                distances[$0.0] = [:]
            }
            if distances[$0.1] == nil {
                distances[$0.1] = [:]
            }
            distances[$0.0]?[$0.1] = $0.2
            distances[$0.1]?[$0.0] = $0.2
        }
        
        return distances
    }
}