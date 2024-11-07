//
//  Shop.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class Shop: SKScene {
    
    let backHome = SKShapeNode()
    let background = SKSpriteNode(imageNamed: "spacebackground-small")
    
    let store = SKSpriteNode(imageNamed: "storeMenu")
    let shopButtons = SKSpriteNode(imageNamed: "shopButtons")
    
    var quitButton = SKShapeNode()
    
    var playerCoins: Int! = UserDefaults.standard.integer(forKey: "playerCoins")
    var coinLabel = SKLabelNode()
    
    var playerHealth: Int! = UserDefaults.standard.integer(forKey: "playerHealth")
    
    var healthLabel = SKLabelNode()
    
    var fireRateLabel = SKLabelNode()
    var durabilityLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var coinUpgradeLabel = SKLabelNode()
    
    var fireRateCost: Int! = UserDefaults.standard.integer(forKey: "fireRateCost")
    var durabilityCost: Int! = UserDefaults.standard.integer(forKey: "durabilityCost")
    var scoreCost: Int! = UserDefaults.standard.integer(forKey: "scoreCost")
    var coinUpgradeCost: Int! = UserDefaults.standard.integer(forKey: "coinUpgradeCost")
    
    var fireRate: Int! = UserDefaults.standard.integer(forKey: "fireRate")
    var playerStartingHealth: Int! = UserDefaults.standard.integer(forKey: "playerStartingHealth")
    var durability: Int! = UserDefaults.standard.integer(forKey: "durability")
    var coinMultiplier: Int! = UserDefaults.standard.integer(forKey: "coinMultiplier")
    
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(background)
        
        store.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        store.zPosition = 1
        store.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(store)
        
        shopButtons.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        shopButtons.zPosition = 2
        shopButtons.size = CGSize(width: self.size.width * 0.65, height: self.size.height * 0.37)
        self.addChild(shopButtons)
        
        quitButton = SKShapeNode(ellipseOf: CGSize(width: store.size.width * 0.06, height: store.size.width * 0.06))
        quitButton.position = CGPoint(x: size.width * 0.802, y: size.height * 0.82)
        quitButton.zPosition = 3
        quitButton.fillColor = .clear
        quitButton.strokeColor = .clear
        self.addChild(quitButton)
        
        
//        displayHealthLabel.fontName = "Futura-Bold"
//        displayHealthLabel.fontSize = 14
//        displayHealthLabel.fontColor = SKColor.white
//        displayHealthLabel.position = CGPoint(x: 165, y: size.height - 45)  // Adjust position as needed
//        displayHealthLabel.zPosition = 10
        
        coinLabel = SKLabelNode(text: "\(playerCoins ?? 0)")
        coinLabel.fontName = "Futura-Bold"
        coinLabel.fontSize = 14
        coinLabel.fontColor = SKColor.white
        coinLabel.zPosition = 4
        coinLabel.position = CGPoint(x: size.width * 0.335, y: size.height * 0.65)
        addChild(coinLabel)
        
        if playerStartingHealth <= 3 {
            playerHealth = 3
            UserDefaults.standard.set(playerHealth, forKey: "playerHealth")
        } else {
            playerHealth = playerStartingHealth
        }
        
        healthLabel = SKLabelNode(text: "\(playerHealth ?? 0)")
        healthLabel.fontName = "Futura-Bold"
        healthLabel.fontSize = 14
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 4
        healthLabel.position = CGPoint(x: size.width * 0.7, y: size.height * 0.65)
        addChild(healthLabel)
        
        // If the price has not been set, put it to 200
        if fireRateCost < 200 {
            fireRateCost = 200
            UserDefaults.standard.set(fireRateCost, forKey: "fireRateCost")
        }
        
        fireRateLabel = SKLabelNode(text: "\(fireRateCost ?? 200)")
        fireRateLabel.fontName = "Futura-Bold"
        fireRateLabel.fontSize = 12
        fireRateLabel.fontColor = SKColor.white
        fireRateLabel.zPosition = 4
        fireRateLabel.position = CGPoint(x: size.width * 0.435, y: size.height * 0.455)
        addChild(fireRateLabel)
        
        // set this for durabilityCost
        if durabilityCost < 200 {
            durabilityCost = 200
            UserDefaults.standard.set(durabilityCost, forKey: "durabilityCost")
        }
        
        durabilityLabel = SKLabelNode(text: "\(durabilityCost ?? 200)")
        durabilityLabel.fontName = "Futura-Bold"
        durabilityLabel.fontSize = 12
        durabilityLabel.fontColor = SKColor.white
        durabilityLabel.zPosition = 4
        durabilityLabel.position = CGPoint(x: size.width * 0.74, y: size.height * 0.455)
        addChild(durabilityLabel)
        
        // set this for scoreCost
        if scoreCost < 200 {
            scoreCost = 200
            UserDefaults.standard.set(scoreCost, forKey: "scoreCost")
        }
        
        scoreLabel = SKLabelNode(text: "\(scoreCost ?? 200)")
        scoreLabel.fontName = "Futura-Bold"
        scoreLabel.fontSize = 12
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: size.width * 0.435, y: size.height * 0.318)
        addChild(scoreLabel)
        
        // set this for coinUpgradeCost
        if coinUpgradeCost < 200 {
            coinUpgradeCost = 200
            UserDefaults.standard.set(coinUpgradeCost, forKey: "coinUpgradeCost")
        }
        
        coinUpgradeLabel = SKLabelNode(text: "\(coinUpgradeCost ?? 200)")
        coinUpgradeLabel.fontName = "Futura-Bold"
        coinUpgradeLabel.fontSize = 12
        coinUpgradeLabel.fontColor = SKColor.white
        coinUpgradeLabel.zPosition = 4
        coinUpgradeLabel.position = CGPoint(x: size.width * 0.74, y: size.height * 0.318)
        addChild(coinUpgradeLabel)
        
        let label = SKLabelNode(text: "Shop Screen")
        label.fontName = "Arial-BoldMT"
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
    
    func backToMenu() {
        let homeScreen = HomeScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(homeScreen, transition: transition)
    }
    
//    TODO -- Need to write function to convert labels to end with k when thousand and m when millions, etc
//    TODO -- Write function with parameters for whichever button was pressed to process changes in price and sub coins
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // First, get the touch location relative to the scene
            let location = touch.location(in: self)
            
            // Handle movement knob touches
            if quitButton.contains(location) {
                backToMenu()
            }
        }
    }
    
}
