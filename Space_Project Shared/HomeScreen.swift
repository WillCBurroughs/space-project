//
//  HomeScreen.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class HomeScreen: SKScene {
    
    let levelsButton = SKShapeNode()
    let shopButton = SKShapeNode()
    let menuDisplay = SKSpriteNode(imageNamed: "menu")
    let background = SKSpriteNode(imageNamed: "spacebackground-small")
    
    override func didMove(to view: SKView) {
        
        menuDisplay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        menuDisplay.size = CGSize(width: self.size.width, height: self.size.height)

        self.addChild(menuDisplay)
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: self.size.width, height: self.size.height)
        
        self.addChild(background)
//        // Create the "Levels" button
//        createCapsuleButton(buttonNode: levelsButton, text: "Levels", position: CGPoint(x: size.width / 2, y: size.height / 2), width: 200, height: 60, parent: self) {
//            let levelsScene = Levels(size: self.size)
//            transitionToScene(view: self.view, scene: levelsScene)
//        }
//
//        // Create the "Shop" button
//        createCapsuleButton(buttonNode: shopButton, text: "Shop", position: CGPoint(x: size.width / 2, y: size.height / 2 - 100), width: 200, height: 60, parent: self) {
//            let shopScene = Shop(size: self.size)
//            transitionToScene(view: self.view, scene: shopScene)
//        }
    }
}
