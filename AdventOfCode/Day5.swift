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
        return 0
    }
}