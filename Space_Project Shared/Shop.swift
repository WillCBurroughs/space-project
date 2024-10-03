//
//  Shop.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class Shop: SKScene {
    
    let backHome = SKShapeNode()
    
    override func didMove(to view: SKView) {
        backgroundColor = .white  // Set a different background color for clarity
        
        createCapsuleButton(buttonNode: backHome, text: "Back to Menu", position: CGPoint(x: size.width / 2, y: size.height / 2 - 100), width: 200, height: 60, parent: self) {
            let homeScene = HomeScreen(size: self.size)
            transitionToScene(view: self.view, scene: homeScene)
        }
        
        let label = SKLabelNode(text: "Shop Screen")
        label.fontName = "Arial-BoldMT"
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
