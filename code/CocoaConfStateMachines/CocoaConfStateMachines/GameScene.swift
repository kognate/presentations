//
//  GameScene.swift
//  CocoaConfStateMachines
//
//  Created by Josh Smith on 7/9/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

class Born: GKState {}
class Alive : GKState {}
class Dying : GKState {}
class Dead : GKState {}

class ConwayStateMachine : GKStateMachine {
    
    func isAlive() -> Bool {
        var result = false
        if let cstate = currentState {
            result = cstate.isKindOfClass(Alive)
            result = result || cstate.isKindOfClass(Dying)
        }
        return result
    }
    
    func color() -> SKColor {
        if isAlive() {
            return SKColor.redColor()
        } else {
            return SKColor.clearColor()
        }
    }
    
    func hasNeighborCount(count: Int) {
        if self.currentState!.isKindOfClass(Alive) {
            switch count {
                case 0,1,4,5,6,7,8:
                    self.enterState(Dying.self)
                default:
                    self.enterState(Alive.self)
            }
        }
        
        if currentState!.isKindOfClass(Dead.self) && count == 3 {
                self.enterState(Born.self)
        }
    }
    
    override func updateWithDeltaTime(sec: NSTimeInterval) {
        if let cstate = currentState {
            if cstate.isKindOfClass(Born.self) {
                self.enterState(Alive.self)
            }
            
            if cstate.isKindOfClass(Dying.self) {
                self.enterState(Dead.self)
            }
        }
    }
}

class ConwayNode : SKSpriteNode {
    let state : ConwayStateMachine = ConwayStateMachine(states: [Born(), Alive(), Dying(), Dead()])

    func updateWithDeltaTime(sec: NSTimeInterval) {
        self.state.updateWithDeltaTime(sec)
        self.color = self.state.color()
    }
}

var lastTime: CFTimeInterval = 0.0
var timeTickDelta: NSTimeInterval = 1.0
var nodeSize: CGSize = CGSizeMake(10, 10)
var gridSize: CGSize = CGSizeMake(40, 40)
let opqueue = NSOperationQueue()

let uniform = GKRandomDistribution.d20()

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        opqueue.maxConcurrentOperationCount = 8
        
        for var i = 0; i < Int(gridSize.width); i++ {
            for var j = 0; j < Int(gridSize.height); j++ {
                let c = ConwayNode()
                c.size = nodeSize
                let xpos = nodeSize.width * CGFloat(i);
                let ypos = nodeSize.height * CGFloat(j);
                c.position = CGPointMake(xpos, ypos)
                c.name = "conway"
                if uniform.nextInt() < 4 {
                    c.state.enterState(Born.self)
                } else {
                    c.state.enterState(Dead.self)
                }

                if let camera = self.childNodeWithName("camera") {
                    camera.addChild(c)
                }
            }
        }
    }
    
    func aliveAtPoint(point: CGPoint) -> Bool {
         if let camera = self.childNodeWithName("camera") {
            let node = camera.nodeAtPoint(point)
            if node != camera {
                let cnode = node as! ConwayNode
                return cnode.state.isAlive()
            } else {
                return false
            }
         } else {
            return false
        }
    }
    
    func liveNeighborCount(centernode: ConwayNode) -> Int {
        var count = 0
            let northXpoint = centernode.position.x + (nodeSize.width / 2)
            let northYPoint = centernode.position.y + (nodeSize.height * 1.5)
            let northPoint = CGPointMake(northXpoint, northYPoint)
            
            if aliveAtPoint(northPoint) {
                count++
            }
            
            let northEastXpoint = centernode.position.x + (nodeSize.width * 1.5)
            let northEastYPoint = centernode.position.y + (nodeSize.height * 1.5)
            let northEastPoint = CGPointMake(northEastXpoint, northEastYPoint)
            
            if aliveAtPoint(northEastPoint) {
                count++
            }
            
            let eastXpoint = centernode.position.x + (nodeSize.width * 1.5)
            let eastYPoint = centernode.position.y + (nodeSize.height / 2)
            let eastPoint = CGPointMake(eastXpoint, eastYPoint)
            
            if aliveAtPoint(eastPoint) {
                count++
            }
            
            let southEastXpoint = centernode.position.x + (nodeSize.width * 1.5)
            let southEastYPoint = centernode.position.y - (nodeSize.height / 2)
            let southEastPoint = CGPointMake(southEastXpoint, southEastYPoint)
            
            if aliveAtPoint(southEastPoint) {
                count++
            }
            
            let southXpoint = centernode.position.x + (nodeSize.width / 2)
            let southYPoint = centernode.position.y - (nodeSize.height / 2)
            let southPoint = CGPointMake(southXpoint, southYPoint)
            
            if aliveAtPoint(southPoint) {
                count++
            }

            let southWestXpoint = centernode.position.x - (nodeSize.width / 2)
            let southWestYPoint = centernode.position.y - (nodeSize.height / 2)
            let southWestPoint = CGPointMake(southWestXpoint, southWestYPoint)
            
            if aliveAtPoint(southWestPoint) {
                count++
            }

            let westXpoint = centernode.position.x - (nodeSize.width / 2)
            let westYPoint = centernode.position.y + (nodeSize.height / 2)
            let westPoint = CGPointMake(westXpoint, westYPoint)
            
            if aliveAtPoint(westPoint) {
                count++
            }

            let northWestXpoint = centernode.position.x - (nodeSize.width / 2)
            let northWestYPoint = centernode.position.y + (nodeSize.height * 1.5)
            let northWestPoint = CGPointMake(northWestXpoint, northWestYPoint)
            
            if aliveAtPoint(northWestPoint) {
                count++
            }
        return count
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (currentTime - lastTime > timeTickDelta) {
            if let camera = self.childNodeWithName("camera") {
                camera.enumerateChildNodesWithName("conway") { (node, stop) in
                    let sprite = node as! ConwayNode
                    sprite.updateWithDeltaTime(currentTime)
                }
                
                camera.enumerateChildNodesWithName("conway") { (node, stop) in
                    opqueue.addOperationWithBlock() {
                        let sprite = node as! ConwayNode
                        let ncount = self.liveNeighborCount(sprite)
                        sprite.state.hasNeighborCount(ncount)
                    }
                }
                opqueue.waitUntilAllOperationsAreFinished()
                lastTime = currentTime
            }
        }
    }
}
