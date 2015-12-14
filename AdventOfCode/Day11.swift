//
//  Day11.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 14/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day11 {
    static func partOne(input: String) -> String {
        var newPassword = input
        repeat {
            newPassword = nextPassword(newPassword)
        } while (!meetsRequirements(newPassword))
        
        return newPassword
    }
    
    static func partTwo(input: String) -> String {
        return partOne(partOne(input))
    }
    
    static let startChar = "a".unicodeScalars.first!
    static let fallthroughChar = "z".unicodeScalars.first!
    
    static func nextPassword(password: String) -> String {
        var carry = true
        var ascii = Array(password.unicodeScalars)
        
        for i in (0..<ascii.count).reverse() {
            if carry && ascii[i] == fallthroughChar {
                carry = true
                ascii[i] = startChar
            } else if carry {
                ascii[i] = UnicodeScalar(ascii[i].value + 1)
                carry = false
            }
        }
        
        return String(ascii.map { Character($0) })
    }
    
    static func meetsRequirements(password: String) -> Bool {
        // Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
        var substringsOfThree = [String]()
        
        for i in 0..<password.characters.count-2 {
            substringsOfThree.append(password.substringWithRange(Range<String.Index>(start: password.startIndex.advancedBy(i), end: password.startIndex.advancedBy(i+3))))
        }
        
        let containsIncreasingSubstring = substringsOfThree.contains { substring in
            let ascii = Array(substring.unicodeScalars)
            return ascii[0].value + 1 == ascii[1].value && ascii[1].value + 1 == ascii[2].value
        }
        
        // Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
        let containsForbiddenLetter = password.characters.contains { letter in
            "iol".containsString(String(letter))
        }
        
        // Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
        var substringsOfTwo = [String]()
        
        for i in 0..<password.characters.count-1 {
            substringsOfTwo.append(password.substringWithRange(Range<String.Index>(start: password.startIndex.advancedBy(i), end: password.startIndex.advancedBy(i+2))))
        }
        
        var successivePairs = false
        let containsTwoPairsOfSameLetter = substringsOfTwo.filter { substring in
            let ascii = Array(substring.unicodeScalars)
            if ascii[0].value == ascii[1].value {
                if !successivePairs {
                    successivePairs = true
                    return true
                }
            }
            successivePairs = false
            return false
        }.count >= 2
        
        
        return containsIncreasingSubstring && !containsForbiddenLetter && containsTwoPairsOfSameLetter
     }
}