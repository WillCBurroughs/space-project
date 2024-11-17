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
        
        // Add the menu display
        menuDisplay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        menuDisplay.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(menuDisplay)
        
        // Add the background
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(background)
    
        // Create invisible buttons for "Levels" and "Shop"
        createButtonNodes()
    }
    
    func createButtonNodes() {
        // Define button sizes relative to screen size for better scaling across devices
        let buttonWidth = size.width * 0.3
        let buttonHeight = size.height * 0.15
        
        // "Levels" button
        let levelsButton = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: 10)
        levelsButton.position = CGPoint(x: size.width / 2, y: size.height * 0.37)  // Position it over the "Levels" button area in the image
        levelsButton.fillColor = .clear  // Make it invisible or semi-transparent for debugging
        levelsButton.zPosition = 10
        levelsButton.strokeColor = .clear
        levelsButton.name = "levelsButton"
        addChild(levelsButton)
        
        // "Shop" button
        let shopButton = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: 10)
        shopButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)  // Position it over the "Shop" button area in the image
        shopButton.fillColor = .clear  // Make it invisible or semi-transparent for debugging
        shopButton.strokeColor = .clear
        shopButton.zPosition = 10
        shopButton.name = "shopButton"
        addChild(shopButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "levelsButton" {
                transitionToLevelsScene()
            } else if node.name == "shopButton" {
                transitionToShopScene()
            }
        }
    }
    
    func transitionToLevelsScene() {
        let levelsScene = NewLevelsScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(levelsScene, transition: transition)
    }

    func transitionToShopScene() {
        let shopScene = Shop(size: size)  
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(shopScene, transition: transition)
    }
}
