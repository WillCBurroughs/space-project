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
    
    var backToLevels = SKShapeNode()
    var restartLevel = SKShapeNode()
    
    var scoreLabel = SKLabelNode(text: "")
    var playerScore = UserDefaults.standard.integer(forKey: "playerScore")
    
    var playerUnhit = UserDefaults.standard.bool(forKey: "playerUnhit")
    
//   Formula for calculating score = Unhit bonus is 10X * Score Multiplier * Scores for enemies beaten * Speed multiplier
//   Formula for calculating stars = < 1000 * level^2 = 1 star, < 2000 * level^2 = 2 star, > 2000 * level^2 = 3 star
    
//  TODO - Add coins and hearts (Done), add function for score
//  Add button to return to levels menu (done) or restart level
    
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
        
        backToLevels = SKShapeNode(ellipseOf: CGSize(width: self.size.width * 0.1, height: self.size.width * 0.1))
        backToLevels.fillColor = SKColor.clear
        backToLevels.strokeColor = SKColor.clear
        backToLevels.position = CGPoint(x: self.size.width * 0.57, y: self.size.height * 0.2)
        backToLevels.zPosition = 5
        addChild(backToLevels)
        
        restartLevel = SKShapeNode(ellipseOf: CGSize(width: self.size.width * 0.1, height: self.size.width * 0.1))
        restartLevel.fillColor = SKColor.clear
        restartLevel.strokeColor = SKColor.clear
        restartLevel.position = CGPoint(x: self.size.width * 0.42, y: self.size.height * 0.2)
        restartLevel.zPosition = 5
        addChild(restartLevel)
        
        scoreLabel = SKLabelNode(text: "\(playerUnhit ? formatNumber(playerScore * 10) : formatNumber(playerScore))")
        scoreLabel.fontName = "Futura-Bold"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.34)
        addChild(scoreLabel)
        
    }
    
    func transitionToLevelsScene() {
        let levelsScene = NewLevelsScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(levelsScene, transition: transition)
    }
    
    func restartCompletedLevel() {
        let gameScene = GameScene(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(gameScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if backToLevels.contains(location) {
                transitionToLevelsScene()
            }
            
            if restartLevel.contains(location){
                restartCompletedLevel()
            }
        }
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
