//
//  Conway.swift
//  conwaysRules
//
//  Created by Josh Smith on 11/6/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Accelerate
import SpriteKit
import GameplayKit

let rand = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: 1, highestValue: 100)

public func genPopulation(col: Int, row: Int) -> [Double] {
    var res: [Double] = []
    for _ in 1...col {
        for _ in 1...row {
            let nInt = rand.nextInt()
            switch nInt {
            case _ where nInt < 30:
                res.append(1.0)
            default:
                res.append(0.0)
            }
        }
    }
    return res
}

func unfairCoin() -> Float {
    let nInt = rand.nextInt()
    switch nInt {
    case _ where nInt < 4:
        return 1.0
    default:
        return 0.0
    }
}

let convMatrix = [ 1.0, 1.0, 1.0,
    1.0, 0.0, 1.0,
    1.0, 1.0, 1.0 ]

public func calcGeneration(population: [Double], row: Int, col: Int, inout buffer: [Double]) -> [Double] {

    vDSP_f3x3D(population, vDSP_Length(row), vDSP_Length(col), convMatrix, &buffer)
    
    let nextstep = buffer.enumerate().map { (index, element) -> Double in
        switch (Int(element)) {
        case _ where (element == 2 && Int(population[index]) == 1):
            return 1.0
        case _ where (element == 3):
            return 1.0
        default:
            return 0.0
        }
    }
    return nextstep
}

public func generateRuleSystem() -> GKRuleSystem {
    let spawnPredicate = NSPredicate(format: "$neighbors == 3", argumentArray:  [])
    let livePredicate = NSPredicate(format: "$neighbors == 2 AND $original == 1", argumentArray:  [])
    
    let spawnRule = GKRule(predicate: spawnPredicate, assertingFact: "Spawn", grade: 1.0)
    let liveRule = GKRule(predicate: livePredicate, assertingFact: "Live", grade: 1.0)
    
    let reallyDeadPredicate = NSPredicate(format: "$neighbors <= 1 OR $neighbors >= 4 OR ($neighbors == 2 AND $original == 0)", argumentArray:  [])
    let reallyDeadrule = GKRule(predicate: reallyDeadPredicate, assertingFact: "Dead", grade: 1.0)
    
    let chainRuleAlive = GKRule(blockPredicate: {(currentSystem) in
        return currentSystem.gradeForFact("Live") > 0.0 || currentSystem.gradeForFact("Spawn") > 0.0
        }, action: { (currentSystem) in
            currentSystem.state["newvalue"] = 1.0
    })
    
    let chainRuleDead = GKRule(blockPredicate: {(currentSystem) in
        return currentSystem.gradeForFact("Dead") > 0.0
        }, action: { (currentSystem) in
            currentSystem.state["newvalue"] = 0.0
    })
    
    let rulesystem = GKRuleSystem()
    rulesystem.addRule(liveRule)
    rulesystem.addRule(reallyDeadrule)
    rulesystem.addRule(spawnRule)
    rulesystem.addRule(chainRuleDead)
    rulesystem.addRule(chainRuleAlive)
    return rulesystem
}

public func generateRuleSystemTwo() -> GKRuleSystem {
    let spawnPredicate = NSPredicate(format: "$neighbors == 3", argumentArray:  [])
    let livePredicate = NSPredicate(format: "$neighbors == 2 && $original == 1", argumentArray:  [])
    
    let spawnRule = GKRule(predicate: spawnPredicate, assertingFact: "Spawn", grade: 1.0)
    let liveRule = GKRule(predicate: livePredicate, assertingFact: "Live", grade: 1.0)
    let fuzzyPredicate = NSPredicate(format: "$neighbors == 5", argumentArray:  [])
    let fuzzyRule = GKRule(predicate: fuzzyPredicate, assertingFact: "Dead", grade: 0.5)
    let reallyDeadPredicate = NSPredicate(format: "$neighbors <= 1 OR ($neighbors == 4 OR ($neighbors > 5 OR ($neighbors == 2 AND $original == 0)))", argumentArray:  [])
    let reallyDeadrule = GKRule(predicate: reallyDeadPredicate, assertingFact: "Dead", grade: 1.0)
    
    let chainRuleLive = GKRule(blockPredicate: {(currentSystem) in
        return currentSystem.gradeForFact("Live") > 0.0
        }, action: { (currentSystem) in
            currentSystem.state["newvalue"] = currentSystem.state["original"]
    })
    
    let chainRuleSpawn = GKRule(blockPredicate: {(currentSystem) in
        return currentSystem.gradeForFact("Spawn") > 0.0
        }, action: { (currentSystem) in
            currentSystem.state["newvalue"] = 1.0
    })
    
    let chainRuleDead = GKRule(blockPredicate: {(currentSystem) in
        return currentSystem.gradeForFact("Dead") > 0.0
        }, action: { (currentSystem) in
            let dead_score = currentSystem.gradeForFact("Dead")
            switch (dead_score) {
            case _ where dead_score == 0.5:
                currentSystem.state["newvalue"] = unfairCoin()
            default:
                currentSystem.state["newvalue"] = 0.0
            }
    })
    
    let rulesystem = GKRuleSystem()
    rulesystem.addRule(liveRule)
    rulesystem.addRule(spawnRule)
    rulesystem.addRule(fuzzyRule)
    rulesystem.addRule(reallyDeadrule)
    rulesystem.addRule(chainRuleDead)
    rulesystem.addRule(chainRuleLive)
    rulesystem.addRule(chainRuleSpawn)
    
    return rulesystem
}


public func calcGenerationsWithRules(population: [Double], row: Int, col: Int, inout buffer: [Double], rulesystem: GKRuleSystem) -> [Double] {
    
    vDSP_f3x3D(population, vDSP_Length(row), vDSP_Length(col), convMatrix, &buffer)
    
    let nextstep = buffer.enumerate().map { (index, element) -> Double in
        rulesystem.reset()
        rulesystem.state["neighbors"] = Int(element)
        rulesystem.state["original"] = Int(population[index])
        rulesystem.evaluate()
        let nval = rulesystem.state["newvalue"] as! Double
        return nval
        }
    return nextstep
}