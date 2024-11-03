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
        
        let label = SKLabelNode(text: "Shop Screen")
        label.fontName = "Arial-BoldMT"
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
