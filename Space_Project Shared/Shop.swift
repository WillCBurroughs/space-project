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
    var fireRateButton = SKShapeNode()
    
    var durabilityLabel = SKLabelNode()
    var durabilityButton = SKShapeNode()
    
    var scoreLabel = SKLabelNode()
    var scoreButton = SKShapeNode()
    
    var coinUpgradeLabel = SKLabelNode()
    var coinUpgradeButton = SKShapeNode()
    
    var fireRateCost: Int! = UserDefaults.standard.integer(forKey: "fireRateCost")
    var durabilityCost: Int! = UserDefaults.standard.integer(forKey: "durabilityCost")
    var scoreCost: Int! = UserDefaults.standard.integer(forKey: "scoreCost")
    var coinUpgradeCost: Int! = UserDefaults.standard.integer(forKey: "coinUpgradeCost")
    
    var fireRateMultiplier = UserDefaults.standard.float(forKey: "fireRateMultiplier")
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
        
        if(fireRateMultiplier < 1){
            fireRateMultiplier = 1
        }
        
        
//      Default prices
        if(fireRateCost < 200){
            fireRateCost = 200
        }
        
        if(durabilityCost < 200){
            durabilityCost = 200
        }
        
        if(scoreCost < 200){
            scoreCost = 200
        }
        
        if(coinUpgradeCost < 200){
            coinUpgradeCost = 200
        }
        
        if (playerHealth < 3) {
            playerHealth = 3
        }
        
//        displayHealthLabel.fontName = "Futura-Bold"
//        displayHealthLabel.fontSize = 14
//        displayHealthLabel.fontColor = SKColor.white
//        displayHealthLabel.position = CGPoint(x: 165, y: size.height - 45)  // Adjust position as needed
//        displayHealthLabel.zPosition = 10

        
        setupLabels()
        
    }
    
    // Utility function to abbreviate numbers
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
    
    func setupLabels() {
        playerCoins = 10000
        coinLabel = SKLabelNode(text: "\(formatNumber(playerCoins))")
        coinLabel.fontName = "Futura-Bold"
        coinLabel.fontSize = 14
        coinLabel.fontColor = SKColor.white
        coinLabel.zPosition = 4
        coinLabel.position = CGPoint(x: size.width * 0.335, y: size.height * 0.65)
        addChild(coinLabel)
        
        healthLabel = SKLabelNode(text: "\(playerHealth ?? 3)")
        healthLabel.fontName = "Futura-Bold"
        healthLabel.fontSize = 14
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 4
        healthLabel.position = CGPoint(x: size.width * 0.7, y: size.height * 0.65)
        addChild(healthLabel)
        
        fireRateButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3 , height: self.size.width * 0.06))
        fireRateButton.fillColor = SKColor.clear
        fireRateButton.strokeColor = SKColor.clear
        fireRateButton.zPosition = 3.9
        fireRateButton.position = CGPoint(x: size.width * 0.35, y: size.height * 0.46)
        addChild(fireRateButton)
        
        fireRateLabel = SKLabelNode(text: "\(formatNumber(fireRateCost))")
        fireRateLabel.fontName = "Futura-Bold"
        fireRateLabel.fontSize = 12
        fireRateLabel.fontColor = SKColor.white
        fireRateLabel.zPosition = 4
        fireRateLabel.position = CGPoint(x: size.width * 0.435, y: size.height * 0.455)
        addChild(fireRateLabel)

        durabilityButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3 , height: self.size.width * 0.06))
        durabilityButton.fillColor = SKColor.clear
        durabilityButton.strokeColor = SKColor.clear
        durabilityButton.zPosition = 3.9
        durabilityButton.position = CGPoint(x: size.width * 0.655, y: size.height * 0.46)
        addChild(durabilityButton)
        
        durabilityLabel = SKLabelNode(text: "\(formatNumber(durabilityCost))")
        durabilityLabel.fontName = "Futura-Bold"
        durabilityLabel.fontSize = 12
        durabilityLabel.fontColor = SKColor.white
        durabilityLabel.zPosition = 4
        durabilityLabel.position = CGPoint(x: size.width * 0.74, y: size.height * 0.455)
        addChild(durabilityLabel)
        
        scoreButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3 , height: self.size.width * 0.06))
        scoreButton.fillColor = SKColor.clear
        scoreButton.strokeColor = SKColor.clear
        scoreButton.zPosition = 3.9
        scoreButton.position = CGPoint(x: size.width * 0.35, y: size.height * 0.323)
        addChild(scoreButton)
        
        scoreLabel = SKLabelNode(text: "\(formatNumber(scoreCost))")
        scoreLabel.fontName = "Futura-Bold"
        scoreLabel.fontSize = 12
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: size.width * 0.435, y: size.height * 0.318)
        addChild(scoreLabel)
        
        coinUpgradeButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3 , height: self.size.width * 0.06))
        coinUpgradeButton.fillColor = SKColor.clear
        coinUpgradeButton.strokeColor = SKColor.clear
        coinUpgradeButton.zPosition = 3.9
        coinUpgradeButton.position = CGPoint(x: size.width * 0.655, y: size.height * 0.323)
        addChild(coinUpgradeButton)
        
        coinUpgradeLabel = SKLabelNode(text: "\(formatNumber(coinUpgradeCost))")
        coinUpgradeLabel.fontName = "Futura-Bold"
        coinUpgradeLabel.fontSize = 12
        coinUpgradeLabel.fontColor = SKColor.white
        coinUpgradeLabel.zPosition = 4
        coinUpgradeLabel.position = CGPoint(x: size.width * 0.74, y: size.height * 0.318)
        addChild(coinUpgradeLabel)
    }
    
//  Will be called on any purchase
    func updateLabels() {
        fireRateLabel.text = formatNumber(fireRateCost ?? 200)
        durabilityLabel.text = formatNumber(durabilityCost ?? 200)
        scoreLabel.text = formatNumber(scoreCost ?? 200)
        coinUpgradeLabel.text = formatNumber(coinUpgradeCost ?? 200)
        coinLabel.text = formatNumber(playerCoins ?? 0)
    }
    
    func upgradeAttribute(attribute: String) {
        switch attribute {
        case "fireRate":
            if playerCoins >= fireRateCost {
                playerCoins -= fireRateCost
                fireRateMultiplier *= 1.5
                fireRateCost *= 3
                UserDefaults.standard.set(playerCoins, forKey: "playerCoins")
                UserDefaults.standard.set(fireRateMultiplier, forKey: "fireRateMultiplier")
                UserDefaults.standard.set(fireRateCost, forKey: "fireRateCost")
                fireRateLabel.text = "\(fireRateCost ?? 200)"
                coinLabel.text = "\(playerCoins ?? 0)"
            }
            
        case "durability":
            if playerCoins >= durabilityCost {
                playerCoins -= durabilityCost
                durability += 1
                durabilityCost *= 3
                UserDefaults.standard.set(playerCoins, forKey: "playerCoins")
                UserDefaults.standard.set(durability, forKey: "durability")
                UserDefaults.standard.set(durabilityCost, forKey: "durabilityCost")
                durabilityLabel.text = "\(durabilityCost ?? 200)"
                coinLabel.text = "\(playerCoins ?? 0)"
            }
            
        case "score":
            if playerCoins >= scoreCost {
                playerCoins -= scoreCost
                // Assuming score has an effect multiplier
                scoreCost *= 3
                UserDefaults.standard.set(playerCoins, forKey: "playerCoins")
                UserDefaults.standard.set(scoreCost, forKey: "scoreCost")
                scoreLabel.text = "\(scoreCost ?? 200)"
                coinLabel.text = "\(playerCoins ?? 0)"
            }
            
        case "coinMultiplier":
            if playerCoins >= coinUpgradeCost {
                playerCoins -= coinUpgradeCost
                coinMultiplier *= 2
                coinUpgradeCost *= 3
                UserDefaults.standard.set(playerCoins, forKey: "playerCoins")
                UserDefaults.standard.set(coinMultiplier, forKey: "coinMultiplier")
                UserDefaults.standard.set(coinUpgradeCost, forKey: "coinUpgradeCost")
                coinUpgradeLabel.text = "\(coinUpgradeCost ?? 200)"
                coinLabel.text = "\(playerCoins ?? 0)"
            }
            
        default:
            break
        }
    }
    
    
    func backToMenu() {
        let homeScreen = HomeScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(homeScreen, transition: transition)
    }
    
//    TODO -- Need to write function to convert labels to end with k when thousand and m when millions b when billions and t for trillions, etc
//    TODO -- Write function with parameters for whichever button was pressed to process changes in price and sub coins
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // First, get the touch location relative to the scene
            let location = touch.location(in: self)
            
            // Handle movement knob touches
            if quitButton.contains(location) {
                backToMenu()
            }
            
            if fireRateLabel.contains(location) || fireRateButton.contains(location) {
                upgradeAttribute(attribute: "fireRate")
                updateLabels()
            }
            
            if durabilityLabel.contains(location) || durabilityButton.contains(location){
                upgradeAttribute(attribute: "durability")
                updateLabels()
            }
            
            if scoreLabel.contains(location) || scoreButton.contains(location) {
                upgradeAttribute(attribute: "score")
                updateLabels()
            }
            
            if coinUpgradeLabel.contains(location) || coinUpgradeButton.contains(location) {
                upgradeAttribute(attribute: "coinMultiplier")
                updateLabels()
            }
        }
    }
    
}
