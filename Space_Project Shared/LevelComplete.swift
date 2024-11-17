//
//  LevelComplete.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 11/10/24.
//


import SpriteKit
import UIKit
import GoogleMobileAds

class LevelComplete: SKScene {
    
    var rewardedViewModel = RewardedViewModel()
    
    var background = SKSpriteNode(imageNamed: "spacebackground-small")
    var level_complete = SKSpriteNode(imageNamed: "level_complete")
    
    var level_just_completed = UserDefaults.standard.integer(forKey: "selectedLevel")
    
    var playerCoins: Int! = UserDefaults.standard.integer(forKey: "playerCoins")
    var coinLabel = SKLabelNode(text: "")
    
    var healthLabel = SKLabelNode(text: "")
    var livesLeftFromLastLevel = UserDefaults.standard.integer(forKey: "livesRemaining")
    
    var backToLevels = SKShapeNode()
    var restartLevel = SKShapeNode()
    
    var scoreLabel = SKLabelNode(text: "")
    var playerScore = UserDefaults.standard.integer(forKey: "playerScore")
    
    var playerUnhit = UserDefaults.standard.bool(forKey: "playerUnhit")
    var tripleCoinsWatchAd = SKShapeNode()
    
    var bestStarsEarnedLevel: Int = 0
    
//   Formula for calculating score = Unhit bonus is 10X * Score Multiplier * Scores for enemies beaten * Speed multiplier
//   Formula for calculating stars = < 1000 * level^2 = 1 star, < 2000 * level^2 = 2 star, > 2000 * level^2 = 3 star
    
//  TODO - Add coins and hearts (Done), add function for score
//  Add button to return to levels menu (done) or restart level
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        Task {
            await rewardedViewModel.loadLevelCompletionAd()
        }
        
        bestStarsEarnedLevel = UserDefaults.standard.integer(forKey: "bestStarsEarnedLevel\(level_just_completed)")
        
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
        healthLabel.fontSize = 26
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 4
        healthLabel.position = CGPoint(x: size.width * 0.335, y: size.height * 0.33)
        addChild(healthLabel)
        
        coinLabel = SKLabelNode(text: "\(formatNumber(playerCoins))")
        coinLabel.fontName = "Futura-Bold"
        coinLabel.fontSize = 26
        coinLabel.fontColor = SKColor.white
        coinLabel.zPosition = 4
        coinLabel.position = CGPoint(x: size.width * 0.325, y: size.height * 0.44)
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
        
        tripleCoinsWatchAd = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.34, height: self.size.height * 0.13))
        tripleCoinsWatchAd.fillColor = SKColor.clear
        tripleCoinsWatchAd.strokeColor = SKColor.clear
        tripleCoinsWatchAd.position = CGPoint(x: self.size.width * 0.60, y: self.size.height * 0.42)
        tripleCoinsWatchAd.zPosition = 6
        addChild(tripleCoinsWatchAd)
        
        // 10 x multiplier for remaining unhit
        if(playerUnhit){
            playerScore *= 10
        }
        
        scoreLabel = SKLabelNode(text: "\(playerUnhit ? formatNumber(playerScore * 10) : formatNumber(playerScore))")
        scoreLabel.fontName = "Futura-Bold"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.34)
        addChild(scoreLabel)
        
        calculateStarsEarned()
        
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
    
    func showLevelCompletionAd() {
        if let viewController = self.view?.window?.rootViewController {
            rewardedViewModel.showLevelCompletionAd(from: viewController)
            
            self.playerCoins *= 3
            UserDefaults.standard.set(self.playerCoins, forKey: "playerCoins")
            self.coinLabel.text = "\(formatNumber(playerCoins))"
            
        } else {
            print("Root view controller is not available.")
        }
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
            
            if tripleCoinsWatchAd.contains(location){
                showLevelCompletionAd()
            }
        }
    }
    
    //   Formula for calculating stars = < 1000 * level^2 = 1 star, < 2000 * level^2 = 2 star, > 2000 * level^2 = 3 star
    
//  Will save user's best performance to this value
    func saveBestStarsForCurrentLevel(stars: Int) {
        // Retrieve the currently saved best stars
        let bestStarsEarnedLevel = UserDefaults.standard.integer(forKey: "bestStarsEarnedLevel\(level_just_completed)")
        
        // Update only if the new stars are better
        if stars > bestStarsEarnedLevel {
            UserDefaults.standard.set(stars, forKey: "bestStarsEarnedLevel\(level_just_completed)")
            print("New best stars for level \(level_just_completed): \(stars)")
        } else {
            print("No update needed for level \(level_just_completed). Current best: \(bestStarsEarnedLevel)")
        }
    }
    
    func calculateStarsEarned(){
        
        var levelAdjustmentFactor = level_just_completed * level_just_completed
        var starsEarned: Int = 0
        
//      1 star performance
        if(playerScore < (levelAdjustmentFactor * 50)){
            create_one_star_visual()
            starsEarned = 1
        }
        else if(playerScore < (levelAdjustmentFactor * 300)){
            create_two_star_visual()
            starsEarned = 2
        }
        else {
            create_three_star_visual()
            starsEarned = 3
        }
        saveBestStarsForCurrentLevel(stars: starsEarned)
    }
    
    
    func create_one_star_visual(){
        
        var star_size = 0.08
        
        var first_star = SKSpriteNode(imageNamed: "goldStar")
        first_star.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.83)
        first_star.zPosition = 10
        first_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        first_star.zRotation = 5 * (CGFloat.pi / 180)
        addChild(first_star)
        
        var second_star = SKSpriteNode(imageNamed: "silverStar")
        second_star.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.86)
        second_star.zPosition = 10
        second_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(second_star)
        
        var third_star = SKSpriteNode(imageNamed: "silverStar")
        third_star.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * 0.83)
        third_star.zPosition = 10
        third_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        third_star.zRotation = -5 * (CGFloat.pi / 180)
        addChild(third_star)
    }
    
    func create_two_star_visual(){
        var star_size = 0.08
        
        var first_star = SKSpriteNode(imageNamed: "goldStar")
        first_star.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.83)
        first_star.zPosition = 10
        first_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        first_star.zRotation = 5 * (CGFloat.pi / 180)
        addChild(first_star)
        
        var second_star = SKSpriteNode(imageNamed: "goldStar")
        second_star.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.86)
        second_star.zPosition = 10
        second_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(second_star)
        
        var third_star = SKSpriteNode(imageNamed: "silverStar")
        third_star.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * 0.83)
        third_star.zPosition = 10
        third_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        third_star.zRotation = -5 * (CGFloat.pi / 180)
        addChild(third_star)
    }
    
    func create_three_star_visual(){
        var star_size = 0.2
        
        var first_star = SKSpriteNode(imageNamed: "purpleStar")
        first_star.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.83)
        first_star.zPosition = 10
        first_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        first_star.zRotation = 5 * (CGFloat.pi / 180)
        addChild(first_star)
        
        var second_star = SKSpriteNode(imageNamed: "purpleStar")
        second_star.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.86)
        second_star.zPosition = 10
        second_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(second_star)
        
        var third_star = SKSpriteNode(imageNamed: "purpleStar")
        third_star.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * 0.83)
        third_star.zPosition = 10
        third_star.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        third_star.zRotation = -5 * (CGFloat.pi / 180)
        addChild(third_star)
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
