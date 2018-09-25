//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

let ruleSystem = GKRuleSystem()

ruleSystem.state["student"] = ["year": 2, "major": "none"]
ruleSystem.state["took"] = ["Calc1": 5, "Calc2" : 1, "Bio1": 3, "History": 4, "EngLit": 2]

let likesMath = NSPredicate(format: "$took.Calc1 >= 3", argumentArray: [])
let likesMathTwo = NSPredicate(format: "$took.Calc2 <= 3", argumentArray: [])
let likesBio = NSPredicate(format: "$took.Bio1 > 3", argumentArray: [])
let likesHistory = NSPredicate(format: "$took.History > 3", argumentArray: [])
let likesEnglish = NSPredicate(format: "$took.EngLit == 5", argumentArray: [])

let rules = [ GKRule(predicate: likesMath, assertingFact: "Math", grade: 0.2),
    GKRule(predicate: likesMathTwo, assertingFact: "Math", grade: 0.4),
    GKRule(predicate: likesBio, assertingFact: "Bio", grade: 0.6),
    GKRule(predicate: likesHistory, assertingFact: "History", grade: 0.5),
    GKRule(predicate: likesEnglish, assertingFact: "English", grade: 0.8)
]

ruleSystem.addRulesFromArray(rules)
ruleSystem.evaluate()
ruleSystem.facts

ruleSystem.gradeForFact("Math")
ruleSystem.gradeForFact("History")

let maybyNotMath = NSPredicate(format: "$took.Calc2 < 2", argumentArray: [])
ruleSystem.addRule(GKRule(predicate: maybyNotMath, retractingFact: "Math", grade: 0.3))
ruleSystem.facts
ruleSystem.gradeForFact("Math")

ruleSystem.evaluate()
ruleSystem.facts
ruleSystem.gradeForFact("Math")
ruleSystem.gradeForFact("History")

// Quick Note, Apple uses structs in their docs
// This is probably a good idea
enum Fact : String {
    case Math = "Math"
    case History = "History"
}

// But it's ugly
ruleSystem.minimumGradeForFacts([Fact.Math.rawValue])

