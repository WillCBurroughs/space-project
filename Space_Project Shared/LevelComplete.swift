//
//  LevelComplete.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 11/10/24.
//


import SpriteKit
import UIKit



class LevelComplete: SKScene {
    
    var background = SKSpriteNode(imageNamed: "spacebackground-small")
    var level_complete = SKSpriteNode(imageNamed: "level_complete")
    
//  TODO - Add coins and hearts, add function for score
//  Add button to return to levels menu or restart level 
    
    override func didMove(to view: SKView) {
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(background)
        
        level_complete.size = CGSize(width: self.size.width, height:  self.size.height)
        level_complete.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        level_complete.zPosition = 2
        addChild(level_complete)
    }

    
}
