//
//  EnemySpawner.swift
//  Subs
//
//  Created by Josh Smith on 11/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import GameplayKit

let rsource = GKRandomSource()
let rando = GKGaussianDistribution(randomSource: rsource, lowestValue: 1, highestValue: 5)

class EnemyExists: GKState {}

//class EnemyCooling: GKState {}

class EnemyEmpty : GKState {}

//class EnemyExists: GKState {
//    override func isValidNextState(stateClass: AnyClass) -> Bool {
//        return stateClass == EnemyCooling.self
//    }
//}
//
class EnemyCooling: GKState {
    var coolingOff: NSTimeInterval = NSTimeInterval(rando.nextInt())
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == EnemyEmpty.self
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        coolingOff = coolingOff - seconds
        if coolingOff < 0 {
            self.stateMachine?.enterState(EnemyEmpty)
            coolingOff = NSTimeInterval(rando.nextInt())
        }
    }
}
//
//class EnemyEmpty : GKState {
//    override func isValidNextState(stateClass: AnyClass) -> Bool {
//        return stateClass == EnemyExists.self
//    }
//}


class EnemyStateMachine : GKStateMachine {
    
    func canSpawn() -> Bool {
        let res = currentState is EnemyEmpty
       return res
       //return canEnterState(EnemyExists)
    }
}

func generateStateMachine() -> EnemyStateMachine {
    let esm = EnemyStateMachine(states: [EnemyEmpty(), EnemyCooling(), EnemyExists()])
    esm.enterState(EnemyEmpty)
    return esm
    
}