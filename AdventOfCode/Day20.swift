//
//  Day20.swift
//  AdventOfCode
//
//  Created by Søren Nielsen on 23/12/2015.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day20 {
    static func partOne(input: String) -> Int {
        let max = Int(Util.splitLines(input).first!)!
        let houseCount = 10_000_000
        let maxElves = 1_000_000
        var houses = Array(count: houseCount, repeatedValue: 0)
        
        Array(1...maxElves).forEach { elf in
            var travellingElf = elf
            while travellingElf < houseCount {
                houses[travellingElf] += elf * 10
                travellingElf += elf
            }
        }
        
        return firstHouse(houses, withAmount: max)
    }
    
    static func partTwo(input: String) -> Int {
        let max = Int(Util.splitLines(input).first!)!
        let houseCount = 10_000_000
        let maxElves = 1_000_000
        var houses = Array(count: houseCount, repeatedValue: 0)
        
        Array(1...maxElves).forEach { elf in
            var travellingElf = elf
            var deliveredTo = 0
            while deliveredTo < 50 && travellingElf < houseCount {
                houses[travellingElf] += elf * 11
                travellingElf += elf
                deliveredTo += 1
            }
        }
        
        return firstHouse(houses, withAmount: max)
    }
    
    static func firstHouse(houses: [Int], withAmount amount: Int) -> Int {
        return houses.mapWithIndex { (house, presents) in
            return (house: house, presents: presents)
            }.filter { (house, presents) in
                return presents > amount
            }.map { (house, presents) in
                return house
            }.first!
    }
}