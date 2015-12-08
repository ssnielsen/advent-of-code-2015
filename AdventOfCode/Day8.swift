//
//  Day8.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 08/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day8 {
    static func partOne(input: String) -> Int {
        return Util.splitLines(input).map { line in
            return processLine(line)
        }.reduce(0) { (res, r) in
            return res + r.0 - r.1
        }
    }
    
    static func processLine(line: String) -> (Int, Int) {
        do {
            let bPattern = "\\\\\\\\"
            let bRe = try NSRegularExpression(pattern: bPattern, options: [])
            let qPattern = "\\\\\\\""
            let qRe = try NSRegularExpression(pattern: qPattern, options: [])
            let hexPattern = "\\\\x[a-f\\d]{2}"
            let hexRe = try NSRegularExpression(pattern: hexPattern, options: [])
            let replaceLine = NSMutableString(string: line)
            
            bRe.replaceMatchesInString(replaceLine, options: [], range: NSRange.init(location: 0, length: replaceLine.length), withTemplate: "ø")
            qRe.replaceMatchesInString(replaceLine, options: [], range: NSRange.init(location: 0, length: replaceLine.length), withTemplate: "ø")
            hexRe.replaceMatchesInString(replaceLine, options: [], range: NSRange.init(location: 0, length: replaceLine.length), withTemplate: "ø")
            
            return (line.characters.count, replaceLine.length - (replaceLine.hasPrefix("\"") ? 1 : 0) - (replaceLine.hasSuffix("\"") ? 1 : 0))
        } catch {
            print("Error in line: \(line)")
            return (0, 0)
        }
    }
}