
import SpriteKit

// First going to add text that gives the current level you are on (Done)
// Next going to add the planet you are traveling to on progress bar -- Need planets as assets

// Then correcting movement
// Then adding speed

// Then more cosmetics to make it look like given design

class GameScene: SKScene, SKPhysicsContactDelegate {

    var joystickHolder: SKShapeNode!
    var movementBall: SKShapeNode!
    var circularSprite: SKSpriteNode!  // The circular sprite that moves (blue ball)
    var redBall: SKShapeNode!  // The bouncing red ball
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    var isJoystickActive = false
    
    let yellowBallCategory: UInt32 = 0x1 << 2  // Category for yellow bullets
    let playerObjectCategory: UInt32 = 0x1 << 0
    let redBallCategory: UInt32 = 0x1 << 1
    
    var holderProgress: SKSpriteNode!
    var shipProgress: SKSpriteNode!
    var shipForProgress: SKSpriteNode!
    var endLevelIcon: SKSpriteNode!
    
//  Used to put level number on the screen
    var levelDisplay = SKLabelNode(text: "Level ")
    
//    Used to determine width of shipProgress
    var shipProgressWidth: CGFloat = 0
    
//    Used to keep track ship speed
    var shipSpeed: CGFloat = 0.1
    
//  add endLevelIcon
    
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastEnemy: TimeInterval = 0
    
//  Detecting collisions with enemy
    let enemyObjectCategory: UInt32 = 0x1 << 3
    
//  Holding Coin area and life area below
    var coinHolder: SKSpriteNode!
    var lifeHolder: SKSpriteNode!
    
//  Need to set coins and lifes currently saved
    let currentLevel = UserDefaults.standard.integer(forKey: "selectedLevel")
    
    let adjustmentFactor = CGFloat(8)
    
//  Used for new movement controls
    var movementBar: SKSpriteNode!
    var movementKnob: SKSpriteNode!
    var isMovementKnobActive = false
    var knobRadius: CGFloat = 50.0
    
    var shipVelocity: CGFloat = 0.0
    var shipAcceleration: CGFloat = 0.1
    var maxShipSpeed: CGFloat = 2.0
    
//  Used to add ship Speed bar and knob and speedShipBar
    var speedBar = SKSpriteNode(imageNamed: "speedBar")
    var speedKnob = SKShapeNode(ellipseOf: CGSize(width: 50, height: 50))
    
//  Used to show current speed will lead from left of speedBar all the way to speedKnob
    var speedShipBar: SKSpriteNode!

//  Used to add hot and cold section
    var hot = SKSpriteNode(imageNamed: "hot")
    var cold = SKSpriteNode(imageNamed: "cold")
    
//  Used to determine if speedbar being moved
    var isSpeedBarMoving = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self  // Set the contact delegate
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // Set screen boundaries
        
        levelDisplay.fontName = "Futura-Bold"
        levelDisplay.fontSize = 20
        
        speedBar.size = CGSize(width: 922 / 5, height: 243 / 5)
        speedBar.position = CGPoint(x: size.width - 150, y: 60)
        addChild(speedBar)
        
//      Adding cold icon to speedBar
        cold.size = CGSize(width: 42, height: 42)
        cold.position = CGPoint(x: size.width - 218.4, y: 60)
        cold.zPosition = 5
        addChild(cold)

//      Adding hot icon to speedBar
        hot.size = CGSize(width: 42, height: 42)
        hot.position = CGPoint(x: size.width - 82, y: 60)
        hot.zPosition = 5
        addChild(hot)

        // Setup speedShipBar
        speedShipBar = SKSpriteNode(color: .clear, size: CGSize(width: 922 / 5, height: 243 / 5))
        speedShipBar.position = CGPoint(x: size.width - 150, y: 60)
        speedShipBar.anchorPoint = CGPoint(x: 0, y: 0.5)  // Anchor on the left
        addChild(speedShipBar)
        
        // Add the speedKnob on top of the bar
        speedKnob.position = CGPoint(x: size.width - 150, y: 60)
        speedKnob.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        addChild(speedKnob)
        
//      Sets our custom font color
        
        levelDisplay.fontColor = SKColor(red: 84/255, green: 93/255, blue: 175/255, alpha: 1.0)
        levelDisplay.position = CGPoint(x: size.width / 2 + 300, y: size.height - 38 - adjustmentFactor)
        levelDisplay.name = "levelDisplay"
        
//      Sets the current level for display
        levelDisplay.text = "Level \(currentLevel)"
        addChild(levelDisplay)
        
//      Creating coinHolder
        coinHolder = SKSpriteNode(imageNamed: "coinSlot")
        coinHolder.position = CGPoint(x: 70, y: size.height - 40)
        coinHolder.size = CGSize(width: 331 / 4, height: 143 / 4)
        addChild(coinHolder)
        
//      Creating lifeHolder
        lifeHolder = SKSpriteNode(imageNamed: "heartSlot")
        lifeHolder.position = CGPoint(x: 160, y: size.height - 40)
        lifeHolder.size = CGSize(width: 331/4, height: 143/4)
        addChild(lifeHolder)
        
        // Add scrolling background
        setupScrollingBackground()
        
        addCircularSprite()  // Add the blue circular sprite
        spawnRedBall()  // Spawn the first red ball
        
        setupProgress()
        
//      Creates movement bar
        addMovementBar()
        
        // Schedule the enemy creation every x seconds
        let spawnAsteroidsAction = SKAction.repeatForever(SKAction.sequence([SKAction.run {
            createAsteroid(scene: self, screenSize: self.size, enemyCategory: self.enemyObjectCategory, playerCategory: self.playerObjectCategory, playerBullet: self.yellowBallCategory)
        }, SKAction.wait(forDuration: 1.0)]))

        self.run(spawnAsteroidsAction)
        
        // Schedule the firing of yellow balls from the blue ball every 0.5 seconds
        let fireAction = SKAction.repeatForever(SKAction.sequence([SKAction.run(fireYellowBall), SKAction.wait(forDuration: 0.5)]))
        run(fireAction)
    }
    
    // Function used to add all progress nodes
    func setupProgress() {
        
//      Progress bar holder 
        holderProgress = SKSpriteNode(imageNamed: "holderProgress")
        holderProgress.position = CGPoint(x: size.width / 2, y: size.height - 30 - adjustmentFactor)
        holderProgress.size = CGSize(width: 400, height: 8)
        addChild(holderProgress)
        
//      Ship that will move to demonstrate progress
        shipForProgress = SKSpriteNode(imageNamed: "shipForProgress")
        shipForProgress.position = CGPoint(x: size.width / 2 - 186, y: size.height - 30 - adjustmentFactor)
        shipForProgress.size = CGSize(width: 32, height: 18)
        addChild(shipForProgress)
        
        // Progress that has been made on level (start from 0 width)
        shipProgress = SKSpriteNode(imageNamed: "shipProgress")
        shipProgress.position = CGPoint(x: holderProgress.position.x - holderProgress.size.width / 2, y: size.height - 30 - adjustmentFactor)
        // Start from the far left
        shipProgress.anchorPoint = CGPoint(x: 0, y: 0.5)  // Anchor at the left edge
        shipProgress.size = CGSize(width: 0, height: 8)  // Start with 0 width
        addChild(shipProgress)
        
//      Determines next planet user will go to
        endLevelIcon = SKSpriteNode(imageNamed: currentLevel <= 13 ? "planet\(currentLevel + 1)" : "planet1")
        endLevelIcon.position = CGPoint(x: size.width / 2 + 200, y: size.height - 30 - adjustmentFactor)
        endLevelIcon.zPosition = 3
        endLevelIcon.size = CGSize(width: 30, height: 30)
        addChild(endLevelIcon)
        
    }
    
    //  Function that moves the ship to the right
    func moveShip() {
        // Move the ship to the right by `shipSpeed`
        shipForProgress.position.x += shipSpeed
        
        // Ensure the ship doesn't move beyond the progress bar's bounds
        let maxXPosition = holderProgress.position.x + holderProgress.size.width / 2 - shipForProgress.size.width / 2
        if shipForProgress.position.x > maxXPosition {
            shipForProgress.position.x = maxXPosition
            
            // Called when level ends
            levelComplete()
        }
        
        // Calculate the width of the progress bar as the ship moves
        let progress = shipForProgress.position.x - (holderProgress.position.x - holderProgress.size.width / 2)
        
        // Update the size of the progress bar as the ship moves to the right
        shipProgress.size = CGSize(width: progress, height: 8)
    }
    
    //  Ends the level, and iterates the highest level beaten if greater than current saved
    func levelComplete() {
        // Retrieve the highest completed level from UserDefaults
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: "highestCompletedLevel")
        
        // Check if the current level is higher than the saved `highestCompletedLevel`
        if currentLevel > highestCompletedLevel {
            // Update `highestCompletedLevel` in UserDefaults
            UserDefaults.standard.set(currentLevel, forKey: "highestCompletedLevel")
            transitionToLevelsScene()
        }
        else {
            transitionToLevelsScene()
        }
        
    }
    
    // Function to add the movement bar and movement knob
    func addMovementBar() {
        // Add movement bar at the bottom of the screen
        movementBar = SKSpriteNode(imageNamed: "MovementController")
        movementBar.size = CGSize(width: 313 / 5, height: 1190 / 5)
        movementBar.position = CGPoint(x: 70, y: size.height / 2 - 30)
        addChild(movementBar)

        // Add movement knob on top of the movement bar
        movementKnob = SKSpriteNode(imageNamed: "MovementKnob")
        movementKnob.size = CGSize(width: 405 / 5 , height: 405 / 5)
        movementKnob.position = movementBar.position
        addChild(movementKnob)
    }
    
    //  Sends player back to levels scene
    func transitionToLevelsScene() {
        let levelsScene = NewLevelsScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(levelsScene, transition: transition)
    }
    
    // MARK: - Scrolling Background Setup
    func setupScrollingBackground() {
        // Create the first background sprite
        background1 = SKSpriteNode(imageNamed: "spacebackground-small")  // Replace with your image name
        background1.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background1.size = self.size
        background1.zPosition = -1  // Ensure it appears behind other nodes
        
        // Create the second background sprite, which starts to the right of the first one
        background2 = SKSpriteNode(imageNamed: "spacebackground-small")  // Replace with your image name
        background2.position = CGPoint(x: self.size.width + self.size.width / 2, y: self.size.height / 2)
        background2.size = self.size
        background2.zPosition = -1
        
        // Add both background nodes to the scene
        addChild(background1)
        addChild(background2)
    }


    // Function to add a circular sprite in the middle of the screen (blue ball)
    func addCircularSprite() {
        circularSprite = SKSpriteNode(imageNamed: "Ship-Level1")
        
        circularSprite.size = CGSize(width: 180, height: 80)
        circularSprite.position = CGPoint(x: 180, y: self.size.height / 2)
        
        // Add physics body to blue ball
        circularSprite.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        circularSprite.physicsBody?.isDynamic = true
        circularSprite.physicsBody?.categoryBitMask = playerObjectCategory
        circularSprite.physicsBody?.contactTestBitMask = enemyObjectCategory
        circularSprite.physicsBody?.collisionBitMask = 0
        circularSprite.physicsBody?.affectedByGravity = false
        
        addChild(circularSprite)
    }
    
    // Function to spawn a bouncing red ball
    func spawnRedBall() {
        redBall = SKShapeNode(circleOfRadius: 20)
        redBall.fillColor = .red
        redBall.strokeColor = .white
        redBall.lineWidth = 5
        
        // Position randomly on the screen
        let randomX = CGFloat.random(in: 100...self.size.width - 100)
        let randomY = CGFloat.random(in: 100...self.size.height - 100)
        redBall.position = CGPoint(x: self.size.width - 50, y: randomY)
        
        // Add physics body to red ball
        redBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        redBall.physicsBody?.isDynamic = true
        redBall.physicsBody?.categoryBitMask = enemyObjectCategory
        redBall.physicsBody?.contactTestBitMask = playerObjectCategory | yellowBallCategory
        redBall.physicsBody?.collisionBitMask = playerObjectCategory
        redBall.physicsBody?.restitution = 1.0  // Make the ball bouncy
        redBall.physicsBody?.linearDamping = 0  // No friction on the ball
        redBall.physicsBody?.angularDamping = 0
        redBall.physicsBody?.friction = 0
        redBall.physicsBody?.affectedByGravity = false
        
        // Add an initial random velocity
        let randomVelocity = CGVector(
            dx: CGFloat.random(in: (-200)...(-100)),  // Always move left (negative dx)
            dy: CGFloat.random(in: -200...200)    // Randomize vertical movement
        )
        redBall.physicsBody?.velocity = randomVelocity
        
        addChild(redBall)
    }
    
    // Function to fire yellow balls from the blue ball
    func fireYellowBall() {
        let yellowBall = SKSpriteNode(imageNamed: "playerLaser")
        
        // Position yellow ball at the blue ball's position
        yellowBall.position = CGPoint(x: circularSprite.position.x + 90, y: circularSprite.position.y)
        
        yellowBall.size = CGSize(width: 30, height: 7)  // Set the laser size
        
        // Add physics body to yellow ball with the same size as the laser
        yellowBall.physicsBody = SKPhysicsBody(rectangleOf: yellowBall.size)  // Use the size of the yellow ball
        yellowBall.physicsBody?.isDynamic = true
        yellowBall.physicsBody?.categoryBitMask = yellowBallCategory
        yellowBall.physicsBody?.contactTestBitMask = enemyObjectCategory
        yellowBall.physicsBody?.collisionBitMask = 0
        yellowBall.physicsBody?.affectedByGravity = false
        
        // Set initial velocity to move right
        yellowBall.physicsBody?.velocity = CGVector(dx: 300, dy: 0)
        
        // Add yellow ball (laser) to the scene
        addChild(yellowBall)
        
        // Action to remove yellow ball when it goes off-screen
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: 5.0), SKAction.removeFromParent()])
        yellowBall.run(removeAction)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if movementKnob.contains(location) {
                isMovementKnobActive = true
            }
            
            if speedKnob.contains(location) {
                isSpeedBarMoving = true
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // Handle movementKnob functionality
            if isMovementKnobActive {
                let knobVectorY = location.y - movementBar.position.y // Only consider vertical movement
                let distance = abs(knobVectorY)  // Only the Y-distance matters

                // If within knob radius, allow free movement
                if distance <= knobRadius {
                    movementKnob.position.y = location.y  // Move only in the Y direction
                } else {
                    // Constrain movement to the knob's Y axis boundary
                    let yPosition = movementBar.position.y + (knobRadius * (knobVectorY / abs(knobVectorY)))  // Move to the top/bottom of the range
                    movementKnob.position.y = yPosition
                }
                
                // Scale movement based on how far the knob is moved vertically
                let moveAmount = (movementKnob.position.y - movementBar.position.y) / knobRadius
                shipVelocity = moveAmount * maxShipSpeed  // Scale by max speed
            }

            // Handle speedKnob functionality (controls horizontal speed)
            if isSpeedBarMoving {
                let knobVectorX = location.x - speedBar.position.x  // Only consider horizontal movement

                // Get the leftmost and rightmost X positions of the speedBar
                let minX = speedBar.position.x - speedBar.size.width / 2 + 24
                let maxX = speedBar.position.x + speedBar.size.width / 2 - 25

                // Clamp the knob's X position within the bounds of the speedBar
                let newXPosition = max(min(location.x, maxX), minX)
                speedKnob.position.x = newXPosition

                // Calculate the width of the speedShipBar based on the knob's position
                var barWidth = newXPosition - minX  // Calculate width relative to the leftmost part

                // Prevent width from being less than a small value (to avoid unwrapping nil or zero-sized width)
                if barWidth < 1 {
                    barWidth = 1
                }

                // Add 40 units to the width
                barWidth += 51

                // Define the height of the speed bar
                let barHeight = speedBar.size.height

                // Adjust the size and apply gradient to speedShipBar
                speedShipBar.size = CGSize(width: barWidth, height: barHeight)

                // Apply the gradient texture
                applyRoundedGradientToSpeedShipBar(speedShipBar: speedShipBar, width: barWidth, height: barHeight, cornerRadius: 25)

                // Adjust the position to keep it anchored to the left, but offset by 20 units to the left
                speedShipBar.position.x = minX - 23  // Shift left by 20 units
                speedShipBar.position.y = speedBar.position.y  // Keep it aligned vertically
            }
        }
    }


    // Function to reset the movement knob's position (animated) back to the center
    func resetMovementKnobPosition() {
        // Ensure the knob is returned to its original position on the bar
        isMovementKnobActive = false
        movementKnob.removeAllActions()  // Stop any ongoing actions
        
        // Reset knob's position to the center of the movement bar
        let moveBackAction = SKAction.move(to: movementBar.position, duration: 0.2)
        moveBackAction.timingMode = .easeOut
        movementKnob.run(moveBackAction)
    }

    // MARK: - Touch Handling
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the knob when touches end
        resetMovementKnobPosition()
        isJoystickActive = false  // Ensure joystick is no longer active
        isSpeedBarMoving = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Also reset the knob if the touch is canceled
        resetMovementKnobPosition()
        isJoystickActive = false
        isSpeedBarMoving = false
    }
    
    // MARK: - Update Cycle
    override func update(_ currentTime: TimeInterval) {
        // Move both backgrounds to the left
        background1.position.x -= 2  // Adjust this speed as needed
        background2.position.x -= 2
        
        moveShip()
        
        // Check if the first background has moved off-screen, then reposition it
        if background1.position.x < -self.size.width / 2 {
            background1.position.x = background2.position.x + self.size.width
        }
        
        // Check if the second background has moved off-screen, then reposition it
        if background2.position.x < -self.size.width / 2 {
            background2.position.x = background1.position.x + self.size.width
        }
        
        // Apply ship movement based on velocity for smoother effect
        circularSprite.position.y += shipVelocity  // Apply the velocity to the Y position
        
        // Apply friction to slowly stop the ship when not actively moving the knob
        shipVelocity *= 1  // Dampen the velocity over time (friction effect)
        
        // Clamp the ship's position to stay within the screen bounds
        let topBound = self.size.height - circularSprite.frame.height / 2 - 50
        let bottomBound = circularSprite.frame.height / 2

        let clampedY = max(min(circularSprite.position.y, topBound), bottomBound)
        circularSprite.position.y = clampedY
    }
    
    // MARK: - Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node

        // Detect collisions between player (blueBall) and enemy objects (e.g., asteroids)
        if (bodyA?.physicsBody?.categoryBitMask == playerObjectCategory && bodyB?.physicsBody?.categoryBitMask == enemyObjectCategory) ||
           (bodyA?.physicsBody?.categoryBitMask == enemyObjectCategory && bodyB?.physicsBody?.categoryBitMask == playerObjectCategory) {

            print("Player collided with an enemy!")
        }

        // Detect collisions between yellowBall and enemy objects (e.g., asteroids)
        if (bodyA?.physicsBody?.categoryBitMask == yellowBallCategory && bodyB?.physicsBody?.categoryBitMask == enemyObjectCategory) ||
           (bodyA?.physicsBody?.categoryBitMask == enemyObjectCategory && bodyB?.physicsBody?.categoryBitMask == yellowBallCategory) {
            bodyA?.removeFromParent()
            bodyB?.removeFromParent()
            print("Yellow ball collided with an asteroid!")
        }
    }
    
    // Function to display messages like "Collision Detected" or "Target Hit"
    func displayCollisionMessage(_ message: String) {
        let collisionLabel = SKLabelNode(text: message)
        collisionLabel.fontSize = 40
        collisionLabel.fontColor = .yellow
        collisionLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        collisionLabel.zPosition = 10
        addChild(collisionLabel)
        
        // Fade out the message after 2 seconds
        let fadeOutAction = SKAction.fadeOut(withDuration: 2.0)
        let removeAction = SKAction.removeFromParent()
        collisionLabel.run(SKAction.sequence([fadeOutAction, removeAction]))
    }
}
