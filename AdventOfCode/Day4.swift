//
//  Day4.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day4 {
    static let lowerBound = 0
    static let upperBound = 10_000_000
    
    static func partOne(input: String) -> Int {
        return solution(input, prefix: "00000")
    }
    
    static func partTwo(input: String) -> Int {
        return solution(input, prefix: "000000")
        
    }
    
    static func solution(input: String, prefix: String) -> Int {
        for i in lowerBound...upperBound {
            let hash = md5("\(input)\(i)")
            if hash.hasPrefix(prefix) {
                return i
            }
        }
        
        return -1
    }
    
    // Source: http://stackoverflow.com/a/32166735/1177835
    static func md5(input: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = input.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}