//
//  SuperSimple.swift
//  CocoaConfStateMachines
//
//  Created by Josh Smith on 7/10/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

class Hastouch : GKState {
    
}
class Movingtouch : GKState { }
class Notouch : GKState { }

class TouchStateMachine : GKStateMachine {
    var lastTime = 0.0
    var colors = [SKColor.redColor(), SKColor.blueColor(), SKColor.greenColor(), SKColor.whiteColor(), SKColor.yellowColor(), SKColor.purpleColor()]
    var currentColor = SKColor.clearColor()
    let uniform = GKRandomDistribution.d6()
    
    func color() -> SKColor {
        return currentColor
    }
    
    override func updateWithDeltaTime(sec: NSTimeInterval) {
        if !currentState!.isKindOfClass(Notouch) {
            if sec - lastTime > 1 {
                currentColor = colors[uniform.nextInt() - 1]
                lastTime = sec
            }
        } else {
            currentColor = SKColor.clearColor()
        }
    }
}

class SimpleStates: SKScene {
    
    let statemachine = TouchStateMachine(states: [Hastouch(), Movingtouch(), Notouch()])
    override func didMoveToView(view: SKView) {
        statemachine.enterState(Notouch.self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        statemachine.enterState(Hastouch.self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        statemachine.enterState(Movingtouch.self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        statemachine.enterState(Notouch.self)
    }
    
    override func update(currentTime: NSTimeInterval) {
        statemachine.updateWithDeltaTime(currentTime)
        self.backgroundColor = statemachine.color()
    }
}
