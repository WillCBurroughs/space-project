//
//  Enemies.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/7/24.
//

import SpriteKit

func createAsteroid(scene: SKScene, screenSize: CGSize, speedMultiplier:CGFloat, enemyCategory: UInt32, playerCategory: UInt32, playerBullet: UInt32, coinValue: Int, pointValue: Int) {
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
    
    // Saves coins on enemy as well as points
    asteroid.userData = ["coinValue": coinValue, "pointValue": pointValue]

    // Move the asteroid from the right to the left across the screen
    let baseMoveDuration = TimeInterval(CGFloat.random(in: 5...10))  // Random speed between 5 to 10 seconds
    let moveDuration = baseMoveDuration / Double(speedMultiplier)  // Adjust speed based on the speedMultiplier
    let moveAction = SKAction.moveBy(x: -screenSize.width - asteroid.size.width, y: 0, duration: moveDuration)
    
    // Remove the asteroid once it moves past the left side of the screen
    let removeAction = SKAction.removeFromParent()
    let sequence = SKAction.sequence([moveAction, removeAction])
    
    // Run the sequence of actions
    asteroid.run(sequence)
}

// Testing enemy that follows player up and down screen
func createFollowingEnemy(scene: SKScene, screenSize: CGSize, playerNode: SKSpriteNode, speedMultiplier: CGFloat, enemyCategory: UInt32, playerCategory: UInt32, playerBulletCategory: UInt32, coinValue: Int, pointValue: Int) {
    // Create the enemy node (you can replace this with any image or shape)
    let enemy = SKSpriteNode(imageNamed: "enemyShip")
    enemy.size = CGSize(width: 100, height: 80)  // Set enemy size
    enemy.zPosition = 10  // Ensure it appears above other elements

    // Set the initial position to be just outside the right side of the screen
    let startX = screenSize.width + enemy.size.width / 2
    let randomY = CGFloat.random(in: enemy.size.height...screenSize.height - enemy.size.height)  // Random Y position
    enemy.position = CGPoint(x: startX, y: randomY)

    // Configure the physics body for collisions, but prevent physical movement or rotation
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
    enemy.physicsBody?.isDynamic = true  // Allow the enemy to detect collisions
    enemy.physicsBody?.affectedByGravity = false  // No gravity effect
    enemy.physicsBody?.allowsRotation = false  // No rotation on collisions

    // Set the enemy's category and contact/collision bitmasks
    enemy.physicsBody?.categoryBitMask = enemyCategory
    enemy.physicsBody?.contactTestBitMask = playerCategory | playerBulletCategory  // Detect collisions with player and bullets
    enemy.physicsBody?.collisionBitMask = 0  // No physical collision response

    // Add enemy to the scene
    scene.addChild(enemy)
    
    // Saving how many coins enemy and points
    enemy.userData = ["coinValue": coinValue, "pointValue": pointValue]
    
    // Create an action to follow the player node up and down the screen
    let followAction = SKAction.run {
        let playerYPosition = playerNode.position.y
        let moveAction = SKAction.moveTo(y: playerYPosition, duration: 0.5)  // Enemy follows the player's Y position smoothly
        enemy.run(moveAction)
    }
    let followInterval = SKAction.wait(forDuration: 0.1)  // Adjust to change how often the enemy follows
    let followSequence = SKAction.sequence([followAction, followInterval])
    let repeatFollow = SKAction.repeatForever(followSequence)
    
    // Run the follow sequence
    enemy.run(repeatFollow)

    // Enemy fires at the player periodically
    let fireAction = SKAction.run {
        let bullet = SKSpriteNode(imageNamed: "enemyBullet")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position = enemy.position
        bullet.zPosition = 10

        // Set up bullet's physics body
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = enemyCategory
        bullet.physicsBody?.contactTestBitMask = playerCategory
        bullet.physicsBody?.collisionBitMask = 0
        
        scene.addChild(bullet)

        // Move the bullet toward the player
        let bulletMoveDuration = 1.5 / Double(speedMultiplier)
        let moveBulletAction = SKAction.moveTo(x: playerNode.position.x - screenSize.width, duration: bulletMoveDuration)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction, removeBulletAction]))
    }
    
    // Added to prevent enemy from shooting while off screen
    let initialFireDelay = SKAction.wait(forDuration: 1.0 / speedMultiplier)
    let fireInterval = SKAction.wait(forDuration: 2.0)  // Adjust to change how often the enemy fires
    let fireSequence = SKAction.sequence([initialFireDelay, fireAction, fireInterval])
    let repeatFire = SKAction.repeatForever(fireSequence)
    
    // Run the fire sequence
    enemy.run(repeatFire)

    // Move the enemy from the right to the left across the screen
    let moveDuration = 8.0 / Double(speedMultiplier)  // Adjust speed based on speedMultiplier
    let moveAction = SKAction.moveBy(x: -screenSize.width - enemy.size.width, y: 0, duration: moveDuration)
    let removeAction = SKAction.removeFromParent()
    let sequence = SKAction.sequence([moveAction, removeAction])
    
    // Run the move sequence
    enemy.run(sequence)
}

// Enemy that follows the user up and down the screen
func createPersistentEnemy(scene: SKScene, screenSize: CGSize, playerNode: SKSpriteNode, speedMultiplier: CGFloat, enemyCategory: UInt32, playerCategory: UInt32, playerBulletCategory: UInt32, coinValue: Int, pointValue: Int) {
    // Create the enemy node
    let enemy = SKSpriteNode(imageNamed: "upDownEnemy")
    enemy.size = CGSize(width: 100, height: 80)
    enemy.zPosition = 10

    // Position at the edge of the screen
    let startX = screenSize.width - enemy.size.width / 2
    let startY = CGFloat.random(in: enemy.size.height...screenSize.height - enemy.size.height)
    enemy.position = CGPoint(x: startX, y: startY)

    // Physics body configuration
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
    enemy.physicsBody?.isDynamic = true
    enemy.physicsBody?.affectedByGravity = false
    enemy.physicsBody?.allowsRotation = false
    enemy.physicsBody?.categoryBitMask = enemyCategory
    enemy.physicsBody?.contactTestBitMask = playerCategory | playerBulletCategory
    enemy.physicsBody?.collisionBitMask = 0

    // Add to the scene
    scene.addChild(enemy)

    // Store coins and points value
    enemy.userData = ["coinValue": coinValue, "pointValue": pointValue]

    // Action to vertically oscillate within the screen bounds
    let moveUp = SKAction.moveTo(y: screenSize.height - enemy.size.height / 2, duration: 2.0 / Double(speedMultiplier))
    let moveDown = SKAction.moveTo(y: enemy.size.height / 2, duration: 2.0 / Double(speedMultiplier))
    let upDownSequence = SKAction.sequence([moveUp, moveDown])
    let repeatUpDown = SKAction.repeatForever(upDownSequence)

    // Run the vertical movement sequence
    enemy.run(repeatUpDown)

    // Enemy fires periodically
    let fireAction = SKAction.run {
        let bullet = SKSpriteNode(imageNamed: "enemyBullet")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position = CGPoint(x: enemy.position.x - bullet.size.width, y: enemy.position.y)
        bullet.zPosition = 10

        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = enemyCategory
        bullet.physicsBody?.contactTestBitMask = playerCategory
        bullet.physicsBody?.collisionBitMask = 0

        scene.addChild(bullet)

        // Move the bullet towards the left of the screen
        let bulletMoveDuration = 2.0 / Double(speedMultiplier)
        let moveBulletAction = SKAction.moveBy(x: -screenSize.width, y: 0, duration: bulletMoveDuration)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction, removeBulletAction]))
    }

    let fireInterval = SKAction.wait(forDuration: 3.0)  // Adjust to change how often the enemy fires
    let repeatFire = SKAction.repeatForever(SKAction.sequence([fireAction, fireInterval]))

    // Run the firing sequence
    enemy.run(repeatFire)
}

// Shooting satellite with laser 
func createSatelliteWithLaser(scene: SKScene, screenSize: CGSize, speedMultiplier: CGFloat, enemyCategory: UInt32, playerCategory: UInt32, playerBullet: UInt32, coinValue: Int, pointValue: Int) {
    let satellite = SKSpriteNode(imageNamed: "satellite")
    satellite.size = CGSize(width: 90, height: 90)
    satellite.zPosition = 10
    let startX = screenSize.width + satellite.size.width / 2
    satellite.position = CGPoint(x: startX, y: screenSize.height / 2)

    satellite.physicsBody = SKPhysicsBody(rectangleOf: satellite.size)
    satellite.physicsBody?.isDynamic = true
    satellite.physicsBody?.affectedByGravity = false
    satellite.physicsBody?.allowsRotation = false
    satellite.physicsBody?.categoryBitMask = enemyCategory
    satellite.physicsBody?.contactTestBitMask = playerBullet
    satellite.physicsBody?.collisionBitMask = 0

    let laserBeam = SKSpriteNode(color: .red, size: CGSize(width: 5, height: screenSize.height))
    laserBeam.anchorPoint = CGPoint(x: 0.5, y: 1)  // Adjust this as needed
    laserBeam.position = CGPoint(x: 0, y: -satellite.size.height / 2)
    laserBeam.zPosition = 9

    laserBeam.physicsBody = SKPhysicsBody(rectangleOf: laserBeam.size)
    laserBeam.physicsBody?.isDynamic = false
    laserBeam.physicsBody?.categoryBitMask = enemyCategory
    laserBeam.physicsBody?.contactTestBitMask = playerCategory
    laserBeam.physicsBody?.collisionBitMask = 0

    satellite.addChild(laserBeam)
    scene.addChild(satellite)

    satellite.userData = ["coinValue": coinValue, "pointValue": pointValue]

    let moveDistance = screenSize.width + satellite.size.width
    let moveDuration = 8.0 / Double(speedMultiplier)
    let moveAction = SKAction.moveBy(x: -moveDistance, y: 0, duration: moveDuration)
    let removeAction = SKAction.removeFromParent()
    satellite.run(SKAction.sequence([moveAction, removeAction]))
}
