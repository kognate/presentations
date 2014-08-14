//
//  GameScene.swift
//  SpaceShipGuitar
//
//  Created by Josh Smith on 8/13/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.

import SpriteKit

class GameScene: SKScene {
    var sounds: [String: AnyObject] = ["one" : 1]
    var actions: [SKAction] = []
    var lastDeltaTime: NSTimeInterval = 0.0
    var editTime: CFTimeInterval = 0.0
    var editing: Bool = false
    
    func enterEditMode() {
        self.editing = true
    }
    
    func reset() {
        self.editing = false
        let ship = self.childNodeWithName("ship")
        ship.removeAllActions()
        self.actions = []
    }
    
    func play() {
        self.editing = false
        self.lastDeltaTime = 0.0
        self.editTime = 0.0
        let ship = self.childNodeWithName("ship")
        ship.runAction(SKAction.sequence(self.actions))
    }
    
    override func didMoveToView(view: SKView) {
        self.name = "scene"
        self.sounds = [ "string_one" : SKAction.playSoundFileNamed("tone_one.m4a", waitForCompletion:false),
            "string_two" : SKAction.playSoundFileNamed("tone_two.m4a", waitForCompletion:false),
            "string_three" : SKAction.playSoundFileNamed("tone_three.m4a", waitForCompletion:false),
            "string_four" : SKAction.playSoundFileNamed("tone_four.m4a", waitForCompletion:false),
            "string_five" : SKAction.playSoundFileNamed("tone_five.m4a", waitForCompletion:false),
            "string_six" : SKAction.playSoundFileNamed("tone_six.m4a", waitForCompletion:false),
            "string_seven" : SKAction.playSoundFileNamed("tone_seven.m4a", waitForCompletion:false),
            "string_eight" : SKAction.playSoundFileNamed("tone_eight.m4a", waitForCompletion:false),
            "string_nine" : SKAction.playSoundFileNamed("tone_nine.m4a", waitForCompletion:false),
            "string_ten" : SKAction.playSoundFileNamed("tone_ten.m4a", waitForCompletion:false)]
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        
        let currentTouch = touches.anyObject() as UITouch
        
        let touchLoc = currentTouch.locationInNode(self)
        let plucked = self.nodeAtPoint(touchLoc)
        
        if plucked.name != "scene" || plucked.name != "ship" {

            if (self.editing) {
                let moveaction = SKAction.moveTo(currentTouch.locationInNode(self), duration: self.lastDeltaTime)
                self.actions.append(moveaction)
                
                if let soundaction = self.sounds[plucked.name] as? SKAction {
                        self.actions.append(soundaction)
//                        self.actions.append(SKAction.group([soundaction, self.pulse()]))
                    }
                self.editTime = 0.0;
            }
            let ship = self.childNodeWithName("ship");
            
            if let soundaction = self.sounds[plucked.name] as? SKAction {
                let actions : [SKAction] = [SKAction.moveTo(currentTouch.locationInNode(self), duration: 0.2),soundaction]
                        let actionstorun = SKAction.sequence(actions)
                        ship.runAction(actionstorun)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if (self.editing) {
            if (self.editTime == 0.0 || self.actions.count == 0) {
               self.editTime = currentTime
               self.lastDeltaTime = 0.0;
            } else {
                self.lastDeltaTime += currentTime - self.editTime
                self.editTime = currentTime
            }
        } else {
            self.editTime = 0.0
            self.lastDeltaTime = 0.0;
        }
        
    }
    
    func pulse() -> SKAction {
        let actionseq = [ SKAction.group([ SKAction.scaleBy(1.2, duration: 0.2), SKAction.rotateToAngle(0.1, duration: 0.2)]),
                          SKAction.group([ SKAction.scaleBy(0.8, duration: 0.2), SKAction.rotateToAngle(0, duration: 0.2)])]
        return SKAction.sequence(actionseq)
    }
}
