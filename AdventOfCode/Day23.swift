//
//  Day23.swift
//  AdventOfCode
//
//  Created by Søren Nielsen on 23/12/2015.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day23 {
    static func partOne(input: String) -> Int {
        var registers = ["a": 0, "b": 0]
        let program = parseInput(input)
        
        evaluateProgram(program, registers: &registers)
        
        return registers["b"]!
    }
    
    static func partTwo(input: String) -> Int {
        var registers = ["a": 1, "b": 0]
        let program = parseInput(input)
        
        evaluateProgram(program, registers: &registers)
        
        return registers["b"]!
    }
    
    static func evaluateProgram(program: [Instruction], inout registers: [String:Int], pointer: Int = 0) {
        if 0 > pointer || pointer >= program.count {
            return
        }
        
        switch program[pointer] {
        case let .Half(register):
            registers[register]! /= 2
            evaluateProgram(program, registers: &registers, pointer: pointer + 1)
        case let .Triple(register):
            registers[register]! *= 3
            evaluateProgram(program, registers: &registers, pointer: pointer + 1)
        case let .Increment(register):
            registers[register]! += 1
            evaluateProgram(program, registers: &registers, pointer: pointer + 1)
        case let .Jump(distance):
            evaluateProgram(program, registers: &registers, pointer: pointer + distance)
        case let .JumpIfPositive(register, distance):
            if registers[register]! % 2 == 0 {
                evaluateProgram(program, registers: &registers, pointer: pointer + distance)
            } else {
                evaluateProgram(program, registers: &registers, pointer: pointer + 1)
            }
        case let .JumpIfOne(register, distance):
            if registers[register]! == 1 {
                evaluateProgram(program, registers: &registers, pointer: pointer + distance)
            } else {
                evaluateProgram(program, registers: &registers, pointer: pointer + 1)
            }
        case .Fault:
            print("Program contains faulty instruction. Exiting")
            return
        }
    }
    
    static func parseInput(input: String) -> [Instruction] {
        return Util.splitLines(input).map { line in
            let components = line.componentsSeparatedByString(" ")
            
            switch components[0] {
            case "hlf":
                return .Half(register(components))
            case "tpl":
                return .Triple(register(components))
            case "inc":
                return .Increment(register(components))
            case "jmp":
                return .Jump(jumpDistance(components))
            case "jie":
                return .JumpIfPositive(register(components), jumpDistance(components))
            case "jio":
                return .JumpIfOne(register(components), jumpDistance(components))
            default:
                print("\(components[0]) is not a valid instruction")
                return .Fault
            }
        }
    }
    
    static func register(components: [String]) -> String {
        return components[1].substringToIndex(components[1].startIndex.advancedBy(1))
    }
    
    static func jumpDistance(components: [String]) -> Int {
        return Int(components.last!)!
    }
}

enum Instruction {
    case Half(String)
    case Triple(String)
    case Increment(String)
    case Jump(Int)
    case JumpIfPositive(String, Int)
    case JumpIfOne(String, Int)
    case Fault
}