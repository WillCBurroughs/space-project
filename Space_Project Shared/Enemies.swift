//
//  Enemies.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/7/24.
//

import SpriteKit

func createAsteroid(scene: SKScene, screenSize: CGSize) {
    // Create the asteroid node
    let asteroid = SKSpriteNode(imageNamed: "asteroid") // Replace with your asteroid image
    asteroid.size = CGSize(width: 90, height: 70) // Set asteroid size
    asteroid.zPosition = 10  // Ensure it appears above other elements
    
    // Set the initial position just outside the right side of the screen
    let startX = screenSize.width + asteroid.size.width / 2
    let randomY = CGFloat.random(in: asteroid.size.height...screenSize.height - asteroid.size.height) // Random Y position
    asteroid.position = CGPoint(x: startX, y: randomY)
    
    // Add physics body to detect collisions, but don't affect movement
    asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
    asteroid.physicsBody?.isDynamic = true   // Allow detection, but asteroid won't be physically impacted by forces
    asteroid.physicsBody?.affectedByGravity = false   // No gravity effect
    asteroid.physicsBody?.allowsRotation = false      // No rotation on collisions
    
    // Adjust settings to prevent movement issues
    asteroid.physicsBody?.mass = 10000                 // Very high mass so it won't be impacted by other objects
    asteroid.physicsBody?.linearDamping = 1            // Slow down movement if needed (you can adjust this)
    
    // Set the collision/contact bitmasks (adjust according to your needs)
    asteroid.physicsBody?.categoryBitMask = 0x1 << 3   // Replace with appropriate category
    asteroid.physicsBody?.contactTestBitMask = 0x1 << 0  // Replace with appropriate contact test
    asteroid.physicsBody?.collisionBitMask = 0          // No physical collision response
    
    // Debugging: Ensure asteroid is created and print frame size
    print("Asteroid being created at position: \(asteroid.position.x), \(asteroid.position.y)")
    print("Asteroid frame: \(asteroid.frame)")
    
    // Add the asteroid to the scene
    scene.addChild(asteroid)
    
    // Move the asteroid leftward across the screen
    let moveDuration = TimeInterval(CGFloat.random(in: 5...10))  // Random speed between 5 to 10 seconds
    let moveAction = SKAction.moveBy(x: -screenSize.width - asteroid.size.width, y: 0, duration: moveDuration)
    
    // Remove the asteroid once it moves past the left side of the screen
    let removeAction = SKAction.removeFromParent()
    let sequence = SKAction.sequence([moveAction, removeAction])
    
    // Run the actions
    asteroid.run(sequence)
}
