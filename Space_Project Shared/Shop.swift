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
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(background)
        
        createCapsuleButton(buttonNode: backHome, text: "Back to Menu", position: CGPoint(x: size.width / 2, y: size.height / 2 - 100), width: 200, height: 60, parent: self) {
            let homeScene = HomeScreen(size: self.size)
            transitionToScene(view: self.view, scene: homeScene)
        }
        
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
