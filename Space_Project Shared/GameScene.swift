
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var joystickHolder: SKShapeNode!
    var movementBall: SKShapeNode!
    var circularSprite: SKSpriteNode!  // The circular sprite that moves (blue ball)
    var redBall: SKShapeNode!  // The bouncing red ball
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    var isJoystickActive = false
    var knobRadius: CGFloat = 30.0 // Radius of the joystick holder (joystick base)
    
    let yellowBallCategory: UInt32 = 0x1 << 2  // Category for yellow bullets
    let playerObjectCategory: UInt32 = 0x1 << 0
    let redBallCategory: UInt32 = 0x1 << 1
    
    var holderProgress: SKSpriteNode!
    var shipProgress: SKSpriteNode!
    var shipForProgress: SKSpriteNode!
    var endLevelIcon: SKSpriteNode!
    
//    Used to determine width of shipProgress
    var shipProgressWidth: CGFloat = 0
    
//    Used to keep track ship speed
    var shipSpeed: CGFloat = 1
    
//  add endLevelIcon
    
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastEnemy: TimeInterval = 0
    
//  Detecting collisions with enemy
    let enemyObjectCategory: UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self  // Set the contact delegate
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // Set screen boundaries
        
        // Add scrolling background
        setupScrollingBackground()
        
        addCircularSprite()  // Add the blue circular sprite
        spawnRedBall()  // Spawn the first red ball
        addJoystick()  // Add the joystick
        
        setupProgress()
        
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
        holderProgress.position = CGPoint(x: size.width / 2, y: size.height - 30)
        holderProgress.size = CGSize(width: 400, height: 8)
        addChild(holderProgress)
        
//      Ship that will move to demonstrate progress
        shipForProgress = SKSpriteNode(imageNamed: "shipForProgress")
        shipForProgress.position = CGPoint(x: size.width / 2 - 186, y: size.height - 30)
        shipForProgress.size = CGSize(width: 32, height: 18)
        addChild(shipForProgress)
        
        // Progress that has been made on level (start from 0 width)
        shipProgress = SKSpriteNode(imageNamed: "shipProgress")
        shipProgress.position = CGPoint(x: holderProgress.position.x - holderProgress.size.width / 2, y: size.height - 30)
        // Start from the far left
        shipProgress.anchorPoint = CGPoint(x: 0, y: 0.5)  // Anchor at the left edge
        shipProgress.size = CGSize(width: 0, height: 8)  // Start with 0 width
        addChild(shipProgress)
        
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
        
        let currentLevel = UserDefaults.standard.integer(forKey: "selectedLevel")

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
        circularSprite.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
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

    // Function for adding joystick initially
    func addJoystick() {
        joystickHolder = SKShapeNode(circleOfRadius: 30)
        joystickHolder.fillColor = .lightGray
        joystickHolder.position = CGPoint(x: 70, y: 50)
        addChild(joystickHolder)
        
        movementBall = SKShapeNode(circleOfRadius: 15)
        movementBall.fillColor = .gray
        movementBall.position = joystickHolder.position // Start at center of holder
        addChild(movementBall)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if movementBall.contains(location) {
                isJoystickActive = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isJoystickActive else { return }
        for touch in touches {
            let location = touch.location(in: self)
            let joystickVector = CGVector(dx: location.x - joystickHolder.position.x, dy: location.y - joystickHolder.position.y)
            let distance = sqrt(joystickVector.dx * joystickVector.dx + joystickVector.dy * joystickVector.dy)
            
            if distance <= knobRadius {
                movementBall.position = location
            } else {
                let angle = atan2(joystickVector.dy, joystickVector.dx)
                let xPosition = cos(angle) * knobRadius
                let yPosition = sin(angle) * knobRadius
                movementBall.position = CGPoint(x: joystickHolder.position.x + xPosition, y: joystickHolder.position.y + yPosition)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementBall.position = joystickHolder.position
        isJoystickActive = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementBall.position = joystickHolder.position
        isJoystickActive = false
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
        
        // Move the player and handle joystick control
        guard isJoystickActive else { return }
        let joystickVector = CGVector(dx: movementBall.position.x - joystickHolder.position.x, dy: movementBall.position.y - joystickHolder.position.y)
        let moveSpeed: CGFloat = 0.1
        let newPosition = CGPoint(x: circularSprite.position.x + joystickVector.dx * moveSpeed, y: circularSprite.position.y + joystickVector.dy * moveSpeed)
        let clampedX = max(min(newPosition.x, self.size.width - circularSprite.frame.width / 2), circularSprite.frame.width / 2)
        let clampedY = max(min(newPosition.y, self.size.height - circularSprite.frame.height / 2), circularSprite.frame.height / 2)
        circularSprite.position = CGPoint(x: clampedX, y: clampedY)
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
