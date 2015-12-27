//
//  Day21.swift
//  AdventOfCode
//
//  Created by Søren Nielsen on 26/12/2015.
//  Copyright © 2015 e-conomic A/S. All rights reserved.
//

import Foundation

class Day21 {
    static func partOne(input: String) -> Int {
        let boss = getBoss(input)
        let builds = computeBuilds()
        
        return builds.map { build in
            return (build.0, matchup(build.1, boss: boss))
            }.filter { (_, won) in
                return won
            }.map { (gold, _) in
                return gold
            }.sort().first!
    }
    
    static func partTwo(input: String) -> Int {
        let boss = getBoss(input)
        let builds = computeBuilds()
        
        return builds.map { build in
            return (build.0, matchup(build.1, boss: boss))
            }.filter { (_, won) in
                return !won
            }.map { (gold, _) in
                return gold
            }.sort().last!
    }
    
    static func computeBuilds() -> [(Int, Player)] {
        var builds = [(Int,Player)]()
        
        for weapon in weapons {
            for armor in armors {
                for ring1Index in 0..<rings.count {
                    for ring2Index in 0..<rings.count {
                        if (rings[ring1Index] == nil && rings[ring2Index] == nil) || ring1Index == ring2Index {
                            continue
                        }
                        
                        let ring1 = rings[ring1Index]
                        let ring2 = rings[ring2Index]
                        
                        let damagePoints = weapon.damage + (armor?.damage ?? 0) + (ring1?.damage ?? 0) + (ring2?.damage ?? 0)
                        let armorPoints = weapon.armor + (armor?.armor ?? 0) + (ring1?.armor ?? 0) + (ring2?.armor ?? 0)
                        let cost = weapon.cost + (armor?.cost ?? 0) + (ring1?.cost ?? 0) + (ring2?.cost ?? 0)
                        let build = Player(hitpoints: 100, damage: damagePoints, armor: armorPoints)
                        builds.append((cost, build))
                    }
                }
            }
        }
        
        return builds
    }
    
    static func matchup(var player: Player, var boss: Player) -> Bool {
        var turn = Turn.Player
        
        while (player.hitpoints > 0 && boss.hitpoints > 0) {
            switch turn {
            case .Player:
                boss.hitpoints -= fight(player, defender: boss)
                turn = .Boss
            case .Boss:
                player.hitpoints -= fight(boss, defender: player)
                turn = .Player
            }
        }
        
        return boss.hitpoints <= 0
    }
    
    enum Turn {
        case Player, Boss
    }
    
    static func fight(attacker: Player, defender: Player) -> Int {
        return max(attacker.damage - defender.armor, 1)
    }
    
    static func getBoss(input: String) -> Player {
        let lines = Util.splitLines(input).map { line in
            return Int(line.componentsSeparatedByString(": ").last!)!
        }
        
        return Player(hitpoints: lines[0], damage: lines[1], armor: lines[2])
    }
    
    struct Player {
        var hitpoints: Int
        let damage: Int
        let armor: Int
    }
    
    struct Item {
        let name: String
        let cost: Int
        let damage: Int
        let armor: Int
    }
    
    static let weapons = [
        Item(name: "Dagger",     cost: 8,  damage: 4, armor: 0),
        Item(name: "Shortsword", cost: 10, damage: 5, armor: 0),
        Item(name: "Warhammer",  cost: 25, damage: 6, armor: 0),
        Item(name: "Longsword",  cost: 40, damage: 7, armor: 0),
        Item(name: "Greataxe",   cost: 74, damage: 8, armor: 0)
    ]
    
    static let armors: [Item?] = [
        Item(name: "Leather",    cost: 13,  damage: 0, armor: 1),
        Item(name: "Chainmail",  cost: 31,  damage: 0, armor: 2),
        Item(name: "Splintmail", cost: 53,  damage: 0, armor: 3),
        Item(name: "Bandedmail", cost: 75,  damage: 0, armor: 4),
        Item(name: "Platemail",  cost: 102, damage: 0, armor: 5),
        nil
    ]
    
    static let rings: [Item?] = [
        Item(name: "Damage+1",  cost: 25,  damage: 1, armor: 0),
        Item(name: "Damage+2",  cost: 50,  damage: 2, armor: 0),
        Item(name: "Damage+3",  cost: 100, damage: 3, armor: 0),
        Item(name: "Defense+1", cost: 20,  damage: 0, armor: 1),
        Item(name: "Defense+2", cost: 40,  damage: 0, armor: 2),
        Item(name: "Defense+3", cost: 80,  damage: 0, armor: 3),
        nil
    ]
}