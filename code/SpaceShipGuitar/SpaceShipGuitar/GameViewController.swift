//
//  GameViewController.swift
//  SpaceShipGuitar
//
//  Created by Josh Smith on 8/13/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Pick a size for the scene */
        let scene = GameScene(fileNamed:"GameScene")
        // Configure the view.
        let skView = self.view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        let skv = self.view as SKView
        let scene = skv.scene as GameScene;
        scene.reset();
    }
    
    @IBAction func doubleTwoTap(sender: AnyObject) {
        let skv = self.view as SKView
        let scene = skv.scene as GameScene
        scene.play()
    }

    @IBAction func downSwipe(sender: AnyObject) {
        let skv = self.view as SKView
        let scene = skv.scene as GameScene
        scene.enterEditMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
