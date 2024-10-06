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
    let blueBallCategory: UInt32 = 0x1 << 0
    let redBallCategory: UInt32 = 0x1 << 1
    
    var shipHolderProgress: SKSpriteNode!
    var shipProgress: SKSpriteNode!
    var shipForProgress: SKSpriteNode!
    var endLevelIcon: SKSpriteNode!
    
//    First add shipHolderProgress, shipProgress, then add shipForProgress, then finally add endLevelIcon
//    Then move shipForProgress, on bar. Then have action that ends level when reaching this
//    Iterate Level when beating the level and check if this is greater then set this
//    Keep shipProgress and have it get longer as you continue level
//
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self  // Set the contact delegate
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // Set screen boundaries
        
        // Add scrolling background
        setupScrollingBackground()
        
        addCircularSprite()  // Add the blue circular sprite
        spawnRedBall()  // Spawn the first red ball
        addJoystick()  // Add the joystick
        
        setupProgress()
        
        // Schedule the firing of yellow balls from the blue ball every 0.5 seconds
        let fireAction = SKAction.repeatForever(SKAction.sequence([SKAction.run(fireYellowBall), SKAction.wait(forDuration: 0.5)]))
        run(fireAction)
    }
    
    // Function used to add all progress nodes 
    func setupProgress() {
        
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
        circularSprite.physicsBody?.categoryBitMask = blueBallCategory
        circularSprite.physicsBody?.contactTestBitMask = redBallCategory
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
        redBall.physicsBody?.categoryBitMask = redBallCategory
        redBall.physicsBody?.contactTestBitMask = blueBallCategory | yellowBallCategory
        redBall.physicsBody?.collisionBitMask = blueBallCategory
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
        let yellowBall = SKShapeNode(circleOfRadius: 10)
        yellowBall.fillColor = .yellow
        yellowBall.strokeColor = .black
        yellowBall.lineWidth = 2
        
        // Position yellow ball at the blue ball's position
        yellowBall.position = CGPoint(x: circularSprite.position.x + 30, y: circularSprite.position.y)
        
        // Add physics body to yellow ball
        yellowBall.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        yellowBall.physicsBody?.isDynamic = true
        yellowBall.physicsBody?.categoryBitMask = yellowBallCategory
        yellowBall.physicsBody?.contactTestBitMask = redBallCategory
        yellowBall.physicsBody?.collisionBitMask = 0
        yellowBall.physicsBody?.affectedByGravity = false
        
        // Set initial velocity to move right
        yellowBall.physicsBody?.velocity = CGVector(dx: 300, dy: 0)
        
        // Add yellow ball to the scene
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
        
        if (bodyA == circularSprite && bodyB == redBall) || (bodyA == redBall && bodyB == circularSprite) {
            displayCollisionMessage("Collision Detected")
        } else if (bodyA == redBall && bodyB?.physicsBody?.categoryBitMask == yellowBallCategory) || (bodyB == redBall && bodyA?.physicsBody?.categoryBitMask == yellowBallCategory) {
            bodyA?.removeFromParent()  // Remove the yellow ball or red ball
            bodyB?.removeFromParent()
            displayCollisionMessage("Target Hit")
            
            // Spawn a new red ball after the red ball is defeated
            spawnRedBall()
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
