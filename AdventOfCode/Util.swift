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
            return try NSString(contentsOfFile: "~/Developer/AdventOfCode/AdventOfCode/Input/\(day)", encoding: NSUTF8StringEncoding) as String
        } catch {
            print("Cannot find input")
            return nil
        }
    }
    
    static func splitLines(input: String) -> [String] {
        return input.characters.split(isSeparator: {c in c == "\n" || c == "\r\n"}).map { String($0) }
    }
}