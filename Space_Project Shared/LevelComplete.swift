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
    
    var playerCoins: Int! = UserDefaults.standard.integer(forKey: "playerCoins")
    var coinLabel = SKLabelNode(text: "")
    
    var healthLabel = SKLabelNode(text: "")
    var livesLeftFromLastLevel = UserDefaults.standard.integer(forKey: "livesRemaining")
    
//  TODO - Add coins and hearts (Done), add function for score
//  Add button to return to levels menu or restart level
    
    override func didMove(to view: SKView) {
        
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(background)
        
        level_complete.size = CGSize(width: self.size.width, height:  self.size.height)
        level_complete.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        level_complete.zPosition = 2
        addChild(level_complete)
        
        if(livesLeftFromLastLevel == 0) {
            livesLeftFromLastLevel = 3
        }
        
        healthLabel = SKLabelNode(text: "\(formatNumber(livesLeftFromLastLevel))")
        healthLabel.fontName = "Futura-Bold"
        healthLabel.fontSize = 30
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 4
        healthLabel.position = CGPoint(x: size.width * 0.635, y: size.height * 0.34)
        addChild(healthLabel)
        
        coinLabel = SKLabelNode(text: "\(formatNumber(playerCoins))")
        coinLabel.fontName = "Futura-Bold"
        coinLabel.fontSize = 30
        coinLabel.fontColor = SKColor.white
        coinLabel.zPosition = 4
        coinLabel.position = CGPoint(x: size.width * 0.405, y: size.height * 0.34)
        addChild(coinLabel)
    }
    
    func formatNumber(_ number: Int) -> String {
        switch number {
        case 1_000_000_000...:
            return "\(number / 1_000_000_000)b"  // Billion
        case 1_000_000...:
            return "\(number / 1_000_000)m"  // Million
        case 1_000...:
            return "\(number / 1_000)k"  // Thousand
        default:
            return "\(number)"  // Default
        }
    }

    
}
