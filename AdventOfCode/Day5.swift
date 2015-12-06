//
//  Day5.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day5 {
    // TODO: Could use some regex love :)
    static func partOne(input: String) -> Int {
        let vowels = ["a","e","i","o","u"]
        let vowelTest: String -> Bool = { word in
            return word.characters.filter { char in
                return vowels.contains(String(char))
                }.count >= 3
        }
        
        let doubleLetterTest: String -> Bool = { word in
            return word.characters.dropFirst().reduce((result: false, prevLetter: word.characters.first!)) { (res, letter) in
                return (result: res.result || res.prevLetter == letter, prevLetter: letter)
                }.result
        }
        
        let forbiddenSequences = ["ab","cd","pq","xy"]
        let forbiddenSequencesTest: String -> Bool = { word in
            return forbiddenSequences.reduce(true) { (res, forbidden) in
                return res && !word.containsString(forbidden)
            }
        }
        
        return Util.splitLines(input).reduce(0) { (res, word) in
            return vowelTest(word) && doubleLetterTest(word) && forbiddenSequencesTest(word) ? res+1 : res
        }
    }
    
    static func partTwo(input: String) -> Int {
//        let groupRegex = Regex("(?'letters'[a-z]{2})[a-z](?P=letters)")
//        let letterRegex = Regex("(?'letter'[a-z])[a-z](?P=letter)")
        
        let containsTwoOfTheSamePair: String -> Bool = { word in
            var pairs = [String]()
            var index = 0
            let length = word.characters.count
            
            while index < word.characters.count - 1 {
                let this = word[word.startIndex.advancedBy(index)]
                let next = word[word.startIndex.advancedBy(index + 1)]
                let pair = "\(this)\(next)"
                
                if pairs.contains(pair) {
                    return true
                }
                
                pairs.append(pair)
                
                // Skip a letter if three of the same letter occurs, otherwise go to next letter
                index += index < length - 2 && this == next && word[word.startIndex.advancedBy(index + 2)] == next ? 2 : 1
             }
            
            return false
        }
        
        let containsDuplicateWithLetterInbetween: String -> Bool = { word in
            for (index, letter) in word.characters.enumerate() {
                if (index > word.characters.count - 2) {
                    return false
                } else if letter == word[word.startIndex.advancedBy(index + 2)] {
                    return true
                }
            }
            return false
        }
        
        return Util.splitLines(input).reduce(0) { (res, word) in
            return containsTwoOfTheSamePair(word) && containsDuplicateWithLetterInbetween(word) ? res+1 : res
        }
    }
}