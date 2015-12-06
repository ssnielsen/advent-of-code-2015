//
//  Util.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Util {
    static func getInput(day: Int) -> String? {
        do {
            return try NSString(contentsOfFile: "/Users/Soren/Developer/AdventOfCode/AdventOfCode/Input/\(day)", encoding: NSUTF8StringEncoding) as String
        } catch {
            print("Cannot find input")
            return nil
        }
    }
    
    static func splitLines(input: String) -> [String] {
        return input.characters.split(isSeparator: {c in c == "\n" || c == "\r\n"}).map { String($0) }
    }
}

class Regex {
    let internalExpression: NSRegularExpression?
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        do {
            self.internalExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        } catch {
            print("Regex init failed")
            self.internalExpression = nil
        }
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression?.matchesInString(input, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, input.characters.count))
        return matches == nil ? false : matches!.count > 0
    }
}