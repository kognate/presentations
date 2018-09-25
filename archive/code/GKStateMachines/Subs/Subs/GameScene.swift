//
//  GameScene.swift
//  Subs
//
//  Created by Josh Smith on 11/4/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

class Floating : GKState {}
class GoingUp : GKState {}
class GoingDown : GKState {}

let playerSubState = GKStateMachine(states: [Floating(), GoingDown(), GoingUp()])

class GameScene: SKScene {
    let baseGravityY: CGFloat = 200.0
    let esm = generateStateMachine()
    var lastTime = 0.0
    let yLocRandom = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 768)
    
    override func didMoveToView(view: SKView) {
        playerSubState.enterState(Floating)
        self.physicsWorld.gravity = CGVectorMake(0.0,0.0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if let touch = touches.first {
            if let sub = self.childNodeWithName("sub") as! SKSpriteNode? {
                setSubState(sub, touch: touch)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            if let sub = self.childNodeWithName("sub") as! SKSpriteNode? {
                setSubState(sub, touch: touch)
            }
        }
    }
    
    func setSubState(sub: SKSpriteNode, touch: UITouch) {
        let loc = touch.locationInNode(self)
        let delta = loc.y - sub.position.y
        
        switch (delta) {
        case _ where delta < 0:
            playerSubState.enterState(GoingDown)
        case _ where delta > 0:
            playerSubState.enterState(GoingUp)
        default: break
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            if let _ = touches.first {
                playerSubState.enterState(Floating)
            }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        guard lastTime > 0 else {
            lastTime = currentTime
            return
        }
        let delta_t = currentTime - lastTime
        esm.updateWithDeltaTime(delta_t)
        
        if esm.canSpawn() {
            spawnRandomEnemy()
        }
        
        if let sub = self.childNodeWithName("sub") as? SKSpriteNode {

            switch playerSubState.currentState {
            case _ where playerSubState.currentState is GoingDown:
                goDown(sub)
            case _ where playerSubState.currentState is GoingUp:
                goUp(sub)
            default:
                levelOut(sub)
            }
        }
    }
    
    func goDown( player: SKSpriteNode) {
        let rotateDown = SKAction.rotateToAngle(6.19592, duration: 0.2,shortestUnitArc: true)
        player.physicsBody?.applyForce(CGVectorMake(0, -1 * baseGravityY))
        player.runAction(rotateDown)
    }
    
    func goUp( player: SKSpriteNode) {
        let rotateUp = SKAction.rotateToAngle(0.174533, duration: 0.2, shortestUnitArc: true)
        player.physicsBody?.applyForce(CGVectorMake(0, baseGravityY))
        player.runAction(rotateUp)

    }
    
    func levelOut(player: SKSpriteNode) {
        let levelOut = SKAction.rotateToAngle(0, duration: 0.2, shortestUnitArc: true)
        player.runAction(levelOut)
    }
    
    func spawnRandomEnemy() {
        esm.enterState(EnemyExists)
        let enemyShip = SKSpriteNode(imageNamed: "enemySub")
        enemyShip.xScale = -1
        enemyShip.position = CGPointMake(1024, CGFloat(yLocRandom.nextInt()))
        let seq = SKAction.sequence([SKAction.moveToX(-200, duration: 3), SKAction.removeFromParent(), SKAction.runBlock({ self.esm.enterState(EnemyCooling)})])
        self.addChild(enemyShip)
        enemyShip.runAction(seq)
    }
}
