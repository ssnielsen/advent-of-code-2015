//
//  Day3.swift
//  AdventOfCode
//
//  Created by Soren Sonderby Nielsen on 06/12/15.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

struct Location: Equatable {
    var x: Int
    var y: Int
}

func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

class Day3 {
    static func partOne(input: String) -> Int {
        var visited = [Int:[Int:Bool]]()
        
        let result = input.characters.reduce((visited: 0, currentLocation: Location(x: 0, y: 0))) { (res, direction) in
            let newLocation = getNextLocation(res.currentLocation, forDirection: direction)
            
            if visited[newLocation.x]?[newLocation.y] != nil {
                return (visited: res.visited, currentLocation: newLocation)
            } else {
                if visited[newLocation.x] == nil {
                    visited[newLocation.x] = [Int:Bool]()
                }
                visited[newLocation.x]![newLocation.y] = true
                return (visited: res.visited + 1, currentLocation: newLocation)
            }
        }
        return result.visited
    }
    
    static func partTwo(input: String) -> Int {
        var visited = [Int:[Int:Bool]]()
        
        enum Turn {
            case Santa, RoboSanta
        }
        
        let result = input.characters.reduce((turn: Turn.Santa, visited: 0, santaLocation: Location(x: 0, y: 0), roboLocation: Location(x: 0, y: 0))) { (res, direction) in
            
            var nextLocation: Location?
            
            if res.turn == .Santa {
                nextLocation = getNextLocation(res.santaLocation, forDirection: direction)
            } else {
                nextLocation = getNextLocation(res.roboLocation, forDirection: direction)
            }
            
            guard let newLocation = nextLocation else {
                print("ERROR")
                return res
            }
            
            if visited[newLocation.x]?[newLocation.y] != nil {
                return (turn: res.turn == .Santa ? .RoboSanta : .Santa,
                    visited: res.visited,
                    santaLocation: res.turn == .Santa ? newLocation : res.santaLocation,
                    roboLocation: res.turn == .RoboSanta ? newLocation : res.roboLocation)
            } else {
                if visited[newLocation.x] == nil {
                    visited[newLocation.x] = [Int:Bool]()
                }
                visited[newLocation.x]![newLocation.y] = true
                return (turn: res.turn == .Santa ? .RoboSanta : .Santa,
                    visited: res.visited + 1,
                    santaLocation: res.turn == .Santa ? newLocation : res.santaLocation,
                    roboLocation: res.turn == .RoboSanta ? newLocation : res.roboLocation)
            }
        }
        return result.visited
    }
    
    static func getNextLocation(var location: Location, forDirection direction: Character) -> Location {
        switch direction {
            case "^":
                location.y += 1
            case "v":
                location.y -= 1
            case ">":
                location.x += 1
            case "<":
                location.x -= 1
            default:
                break
        }
        return location
    }
}