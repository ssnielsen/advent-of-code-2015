//
//  Day15.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 15/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day15 {
    static func partOne(input: String) -> Int {
        let ingredients = parseInput(input)
        
        makePermutations(ingredients)
        
        return permutations.reduce(Int.min) { (currentMax, permutation) in
            return max(currentMax, score(permutation))
        }
    }
    
    static func partTwo(input: String) -> Int {
        let ingredients = parseInput(input)
        
        makePermutations(ingredients)
        
        return permutations.reduce(Int.min) { (currentMax, permutation) in
            return max(currentMax, score(permutation, calorieGoal: 500))
        }
    }
    
    static let maxTeaspoons = 100
    static var permutations = [[(ingredient: Ingredient, teaspoons: Int)]]()
    static func makePermutations(ingredients: [Ingredient]) {
        func helper(prefix: [(ingredient: Ingredient, teaspoons: Int)], rest: [Ingredient]) {
            let sum = prefix.map({ a in a.teaspoons }).reduce(0, combine: +)
            let ingredient = rest.first!
            
            if rest.count == 1 {
                permutations.append(prefix + [(ingredient: ingredient, teaspoons: maxTeaspoons - sum)])
                return
            }
            
            for i in 1...maxTeaspoons - min(maxTeaspoons-1, sum) {
                var prefixCopy = prefix
                prefixCopy.append((ingredient: ingredient, teaspoons: i))
                helper(prefixCopy, rest: Array(rest.dropFirst(1)))
            }
        }
        helper([], rest: ingredients)
    }
    
    static func score(measurements: [(ingredient: Ingredient, teaspoons: Int)], calorieGoal: Int? = nil) -> Int {
        if let calorieGoal = calorieGoal {
            let calories = measurements.reduce(0) { (res, measurement) in
                return res + measurement.ingredient.calories * measurement.teaspoons
            }
            if calories != calorieGoal {
                return 0
            }
        }
        
        let capacity = measurements.reduce(0) { (res, measurement) in
            return res + measurement.ingredient.capacity * measurement.teaspoons
        }
        let durability = measurements.reduce(0) { (res, measurement) in
            return res + measurement.ingredient.durability * measurement.teaspoons
        }
        let flavor = measurements.reduce(0) { (res, measurement) in
            return res + measurement.ingredient.flavor * measurement.teaspoons
        }
        let texture = measurements.reduce(0) { (res, measurement) in
            return res + measurement.ingredient.texture * measurement.teaspoons
        }
        
        return max(0, capacity) * max(0, durability) * max(0, flavor) * max(0, texture)
    }
    
    static func parseInput(input: String) -> [Ingredient] {
        var re: NSRegularExpression?
        
        do {
            re = try NSRegularExpression(pattern: "(\\D+)\\:\\scapacity\\s([-\\d]+),\\sdurability\\s([-\\d]+),\\sflavor\\s([-\\d]+),\\stexture\\s([-\\d]+),\\scalories\\s([-\\d]+)", options: [])
        } catch { }
        
        return Util.splitLines(input).map { line in
            let matches = re?.matchesInString(line, options: [], range: NSRange.init(location: 0, length: line.characters.count))
            let name = (line as NSString).substringWithRange(matches![0].rangeAtIndex(1))
            let capacity = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(2)))!
            let durability = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(3)))!
            let flavor = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(4)))!
            let texture = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(5)))!
            let calories = Int((line as NSString).substringWithRange(matches![0].rangeAtIndex(6)))!
            
            return Ingredient(name: name, capacity: capacity, durability: durability, flavor: flavor, texture: texture, calories: calories)
        }
    }
    
    class Ingredient {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
        
        init(name: String, capacity: Int, durability: Int, flavor: Int, texture: Int, calories: Int) {
            self.name = name
            self.capacity = capacity
            self.durability = durability
            self.flavor = flavor
            self.texture = texture
            self.calories = calories
        }
    }
}