//
//  GameScene.swift
//  conwaysRules
//
//  Created by Josh Smith on 11/6/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

let rows = 200
let columns = 200

let redC = SKColor.redColor()
let clearC = SKColor.clearColor()

class GameScene: SKScene {
    var population = genPopulation(columns, row: rows)
    var cells: [SKSpriteNode] = []
    var buffer = [Double](count:columns * rows, repeatedValue: 0.0)
    var rulesystem: GKRuleSystem = generateRuleSystem()
    //var rulesystem: GKRuleSystem = generateRuleSystemTwo()
    
    override func didMoveToView(view: SKView) {
        let cell_height = floor(self.size.height  / CGFloat(rows))
        let cell_width = floor(self.size.width / CGFloat(columns))
        for i in 0..<rows {
            for j in 0..<columns {
                let cell_size = CGSizeMake(cell_width, cell_height)
                let cell_color = population[i * j] != 0 ? redC : clearC
                let cell = SKSpriteNode(color: cell_color, size: cell_size)
                let xPos = CGFloat(i) * cell_width
                let yPos = CGFloat(j) * cell_height
                cell.position = CGPointMake(xPos, yPos)
                self.cells.append(cell)
                self.addChild(cell)
            }
        }
        print(view.frame.size)
    }
    
    override func update(currentTime: CFTimeInterval) {
        //        population = calcGeneration(population, row: rows, col: columns, buffer: &buffer)
        population = calcGenerationsWithRules(population, row: rows, col: columns, buffer: &buffer, rulesystem: rulesystem)
        for (index,element) in population.enumerate() {
            let cell_color = element > 0 ? redC : clearC
            cells[index].color = cell_color
        }
    }
}
