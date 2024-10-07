//
//  Enemies.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/7/24.
//

import SpriteKit

func createAsteroid(scene: SKScene, screenSize: CGSize, enemyCategory: UInt32, playerCategory: UInt32, playerBullet: UInt32) {
    // Create the asteroid node (you can replace this with any image or shape)
    let asteroid = SKSpriteNode(imageNamed: "asteroid")
    asteroid.size = CGSize(width: 90, height: 70) // Set asteroid size
    asteroid.zPosition = 10  // Ensure it appears above other elements

    // Set the initial position to be just outside the right side of the screen
    let startX = screenSize.width + asteroid.size.width / 2
    let randomY = CGFloat.random(in: asteroid.size.height...screenSize.height - asteroid.size.height) // Random Y position
    asteroid.position = CGPoint(x: startX, y: randomY)

    // Configure the physics body for collisions, but prevent physical movement or rotation
    asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
    asteroid.physicsBody?.isDynamic = true          // Allow the asteroid to detect collisions
    asteroid.physicsBody?.affectedByGravity = false // No gravity effect
    asteroid.physicsBody?.allowsRotation = false    // No rotation on collisions

    // Set the asteroid's category and contact/collision bitmasks
    asteroid.physicsBody?.categoryBitMask = enemyCategory
    asteroid.physicsBody?.contactTestBitMask = playerCategory | playerBullet // Detect collisions with redBall and yellowBall
    asteroid.physicsBody?.collisionBitMask = 0  // No physical collision response

    // Add asteroid to the scene
    scene.addChild(asteroid)

    // Move the asteroid from the right to the left across the screen
    let moveDuration = TimeInterval(CGFloat.random(in: 5...10))  // Random speed between 5 to 10 seconds
    let moveAction = SKAction.moveBy(x: -screenSize.width - asteroid.size.width, y: 0, duration: moveDuration)
    
    // Remove the asteroid once it moves past the left side of the screen
    let removeAction = SKAction.removeFromParent()
    let sequence = SKAction.sequence([moveAction, removeAction])
    
    // Run the sequence of actions
    asteroid.run(sequence)
}
