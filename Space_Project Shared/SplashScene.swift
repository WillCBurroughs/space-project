//
//  SplashScene.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class SplashScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black  // Or any background color you want
        
        // Display your splash logo or animation
        let logo = SKSpriteNode(imageNamed: "Frame")  // Add your splash logo image
        logo.size = CGSize(width: size.width, height: size.height)
        logo.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(logo)
        
        // Add animation
        logo.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),  // Duration of splash screen
            SKAction.fadeOut(withDuration: 1.0),
            SKAction.run {
                
                // Transition to the GameScene after splash
                let homeScene = HomeScreen(size: self.size)
                transitionToScene(view: self.view, scene: homeScene)
            }
        ]))
    }
}
