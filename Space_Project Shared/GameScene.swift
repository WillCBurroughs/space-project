
import SpriteKit
import GoogleMobileAds

// First going to add text that gives the current level you are on (Done)
// Next going to add the planet you are traveling to on progress bar -- Need planets as assets

// Then correcting movement
// Then adding speed

// Then more cosmetics to make it look like given design

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var lastHitTime: TimeInterval = 0
    let iFrameDuration: TimeInterval = 1.0  // 1 second
    var isInvincible: Bool = false
    
    //  Keeps player shot sound from being fired too often
    var timeSincePlayerShotSound: TimeInterval = 0
    let howOftenPlayerShotSound: TimeInterval = 1
    var shouldSoundShot: Bool = true
    
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
    
    //  Saved speed Multiplier
    let savedSpeedMultiplier = UserDefaults.standard.float(forKey: "speedBarValue")
    var speedMultiplier: CGFloat!
    
    var fireRateMultiplier = UserDefaults.standard.float(forKey: "fireRateMultiplier")
    var coinMultiplier = UserDefaults.standard.float(forKey: "coinMultiplier")
    
    var scoreMultiplier = UserDefaults.standard.float(forKey: "scoreMultiplier")
    
    //  Loading in player health from UserDefaults
    var playerStartingHealth: Int! = UserDefaults.standard.integer(forKey: "playerStartingHealth")
    var playerHealth: Int! = UserDefaults.standard.integer(forKey: "playerHealth")
    var displayHealthLabel = SKLabelNode(text: "")
    
    //  Loading in coin value
    var playerCoins: Int! = UserDefaults.standard.integer(forKey: "playerCoins")
    var coinLabel = SKLabelNode(text: "")
    
    //  Pause button and pause boolean
    var pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var isGamePaused = false
    
    //  All things added to this during pause
    var pauseOverlay: SKSpriteNode?
    var pauseMenu: SKSpriteNode?
    
    // Declaring resume and quit button
    var resumeButton = SKShapeNode(circleOfRadius: 20)
    var quitButton = SKShapeNode(circleOfRadius: 20)
    var resetButton = SKShapeNode(circleOfRadius: 20)
    
    var losingScreen = SKSpriteNode()
    
    // Menu buttons upon losing the level
    var loseScreenQuitButton = SKShapeNode(circleOfRadius: 20)
    var loseScreenRetryButton = SKShapeNode(circleOfRadius: 20)
    
    // User will select this to watch ad and continue
    var loseScreenWatchAdButton = SKShapeNode(circleOfRadius: 20)
    
    // Settings screen area
    var settingsMenu: SKSpriteNode?
    
    // Values passed for calculating score
    //    Total from enemies beaten (Every enemy has different number) * Score Multiplier * 10x if unhit in level * speed multiplier (0.5 to 2.0)
    
    var playerUnhit = UserDefaults.standard.bool(forKey: "playerUnhit")
    var playerScore = UserDefaults.standard.integer(forKey: "playerScore")
    
    let maxSpeedValue = 2.0
    
    //  used to show ad
    let rewardedViewModel = RewardedViewModel()
    
    // Used to keep track of player_lives > 0 (still alive)
//    var player_is_alive = true
//    var death_background = SKSpriteNode(imageNamed: "death_background")
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)

        physicsWorld.contactDelegate = self  // Set the contact delegate
        
        Task {
            await rewardedViewModel.loadAd()
        }
        
        // Give player invincibility upon load in
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // Set screen boundaries
        
        // By default player is unhit
        playerUnhit = true
        UserDefaults.standard.set(playerUnhit, forKey: "playerUnhit")
        
        // Setup the label to display the player's health
        displayHealthLabel.fontName = "Futura-Bold"
        displayHealthLabel.fontSize = 14
        displayHealthLabel.fontColor = SKColor.white
        displayHealthLabel.position = CGPoint(x: 165, y: size.height - 47)  // Adjust position as needed
        displayHealthLabel.zPosition = 10  // Ensure it's in front of other elements
        
        if(fireRateMultiplier < 1){
            fireRateMultiplier = 1
        }
        
        // playerScore must always default to 0 on level load in
        playerScore = 0
        
        if(coinMultiplier < 1){
            coinMultiplier = 1
        }
        
        if(scoreMultiplier < 1){
            scoreMultiplier = 1.0
        }
        
        // Setup display for player's coins
        coinLabel.fontName = "Futura-Bold"
        coinLabel.fontSize = 14
        coinLabel.fontColor = SKColor.white
        coinLabel.position = CGPoint(x: 85, y: size.height - 47)
        coinLabel.zPosition = 10
        
        // Addition of pauseButton to screen
        pauseButton.position = CGPoint(x: size.width - 50, y: size.height - 40)
        pauseButton.zPosition = 94
        pauseButton.size = CGSize(width: 80, height: 80)
        addChild(pauseButton)
        
        //      If not set, set to 3
        if playerStartingHealth <= 3 {
            playerHealth = 3
            playerStartingHealth = 3
            UserDefaults.standard.set(playerHealth, forKey: "playerHealth")
            UserDefaults.standard.set(playerStartingHealth, forKey: "playerStartingHealth")
        } else {
            playerHealth = playerStartingHealth
        }
        
        playerCoins = UserDefaults.standard.integer(forKey: "playerCoins")
        coinLabel.text = "\(formatNumber(playerCoins!))"
        addChild(coinLabel)
        
        
        displayHealthLabel.text =  "\(playerHealth!)"
        addChild(displayHealthLabel)
        
        //      Determines multiplier
        speedMultiplier = CGFloat(1.0)
        
        initializePauseMenu()
        
        levelDisplay.fontName = "Futura-Bold"
        levelDisplay.fontSize = 20
        
        speedBar.size = CGSize(width: 922 / 5, height: 243 / 5)
        speedBar.position = CGPoint(x: size.width - 150, y: 60)
        speedBar.zPosition = 100
        addChild(speedBar)
        
        //      Adding cold icon to speedBar
        cold.size = CGSize(width: 42, height: 42)
        cold.position = CGPoint(x: size.width - 218.4, y: 60)
        cold.zPosition = 50
        addChild(cold)
        
        //      Adding hot icon to speedBar
        hot.size = CGSize(width: 42, height: 42)
        hot.position = CGPoint(x: size.width - 82, y: 60)
        hot.zPosition = 50
        addChild(hot)
        
        // Setup speedShipBar
        speedShipBar = SKSpriteNode(color: .clear, size: CGSize(width: 922 / 5, height: 243 / 5))
        speedShipBar.position = CGPoint(x: size.width - 240, y: 60)
        speedShipBar.anchorPoint = CGPoint(x: 0, y: 0.5)  // Anchor on the left
        applyRoundedGradientToSpeedShipBar(speedShipBar: speedShipBar, width: 922 / 10 + 25, height: 243 / 5, cornerRadius: 25)
        speedShipBar.zPosition = 50
        addChild(speedShipBar)
        
        // Add the speedKnob on top of the bar
        speedKnob.position = CGPoint(x: size.width - 150, y: 60)
        speedKnob.fillColor = UIColor(red: 128 / 255, green: 116 / 255, blue: 128 / 255, alpha: 0.56)
        speedKnob.zPosition = 40
        addChild(speedKnob)
        
        //      Sets our custom font color
        
        levelDisplay.fontColor = SKColor(red: 84/255, green: 93/255, blue: 175/255, alpha: 1.0)
        levelDisplay.position = CGPoint(x: self.size.width * 0.8, y: size.height - 38 - adjustmentFactor)
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
        
        setupProgress()
        
        //      Creates movement bar
        addMovementBar()
        
        // Schedule the enemy creation every x seconds
        startSpawningAsteroids()
        
        //      Used to spawn enemies
        startSpawningEnemies()
        
        if currentLevel >= 3 {
            startCreatingPersistentEnemies()
        }
        
        if currentLevel >= 9 {
            startCreatingSatellites()
        }
        
        // Schedule the firing of yellow balls from the blue ball every 0.5 seconds
        startFiringBullets()
    }
    
    func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        return from + (to - from) * progress
    }
    
    // Fires player bullet
    func startFiringBullets() {
        // Remove any existing fire actions
        removeAction(forKey: "firing")
        
        let fireAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: (1 / Double(fireRateMultiplier)) / Double(speedMultiplier)),  // Wait before firing
            SKAction.run(fireYellowBall)
        ]))
        
        // Run the new fire action
        run(fireAction, withKey: "firing")
    }
    
    // Create bones of pause menu
    func initializePauseMenu() {
        // Create the pause menu node container
        pauseMenu = SKSpriteNode(imageNamed: "pauseMenu")
        pauseMenu?.zPosition = 96  // Above the overlay
        pauseMenu!.size = CGSize(width: 300, height: 300)
        
        // Example: Adding a resume button to the pause menu
        resumeButton.position = CGPoint(x: 50, y: 50)
        resumeButton.fillColor = .blue
        pauseMenu?.addChild(resumeButton)
        
        redBall = SKShapeNode(circleOfRadius: 20)
        redBall.fillColor = .red
        redBall.strokeColor = .white
        redBall.lineWidth = 5
        
        // Example: Adding a quit button to the pause menu
        quitButton = SKShapeNode(circleOfRadius: 20)
        quitButton.fillColor = .red
        quitButton.position = CGPoint(x: 0, y: 50)
        quitButton.strokeColor = .white
        pauseMenu?.addChild(quitButton)
        
        // Initially, the pause menu is hidden
        pauseMenu?.isHidden = true
        
        // Add the pause menu to the scene
        addChild(pauseMenu!)
    }
    
    // Sets up pause features (overlay, buttons, and pause menu)
    func setupPauseScreen() {
        if pauseOverlay == nil {
            // Create and configure the pause overlay
            pauseOverlay = SKSpriteNode(color: SKColor(red: 0, green: 0, blue: 0, alpha: 0.6), size: self.size)
            pauseOverlay?.position = CGPoint(x: size.width / 2, y: size.height / 2)
            pauseOverlay?.zPosition = 95
            addChild(pauseOverlay!)

            // Create pause menu node container
            pauseMenu = SKSpriteNode(imageNamed: "pauseMenu")
            pauseMenu?.zPosition = 96  // Ensure it's on top of the overlay
            pauseMenu!.position = CGPoint(x: size.width / 2, y: size.height / 2)
            pauseMenu!.size = CGSize(width:self.size.width * 0.8, height: self.size.height)

            // Adding a resume button to the pause menu
            let resumeButtonRadius = self.size.width / 28  // Define radius based on screen size
            resumeButton = SKShapeNode(circleOfRadius: resumeButtonRadius)

            // Position it relative to the pauseMenu container's size
            let buttonOffsetY = pauseMenu!.size.height * -0.89  // Adjust this offset based on your design
            resumeButton.position = CGPoint(x: 0 + self.size.width * 0.008, y: pauseMenu!.position.y + buttonOffsetY)
            
            // Button styling
            resumeButton.fillColor = .clear
            resumeButton.strokeColor = .clear
            resumeButton.zPosition = 100
            pauseMenu?.addChild(resumeButton)
            print("Resume button added")
            
            // Example: Adding a quit button to the pause menu
            quitButton = SKShapeNode(circleOfRadius: resumeButtonRadius)
            
            let quitButtonXOffset = self.size.width * 0.1
            
            quitButton.position = CGPoint(x: 0 + quitButtonXOffset, y: pauseMenu!.position.y + buttonOffsetY)
            quitButton.fillColor = .clear
            quitButton.strokeColor = .clear
            quitButton.zPosition = 100
            pauseMenu?.addChild(quitButton)
            print("Quit button added")
            
            resetButton = SKShapeNode(circleOfRadius: resumeButtonRadius)
            
            let resetButtonXOffset = self.size.width * -0.09
            
            resetButton.position = CGPoint(x: 0 + resetButtonXOffset, y: pauseMenu!.position.y + buttonOffsetY)
            resetButton.fillColor = .clear
            resetButton.strokeColor = .clear
            resetButton.zPosition = 100
            pauseMenu?.addChild(resetButton)
        
            var coinsDisplayPauseMenu = SKLabelNode()
            var heartsDisplayPauseMenu = SKLabelNode()
            
            coinsDisplayPauseMenu.fontName = "Futura-Bold"
            coinsDisplayPauseMenu.fontSize = 16
            coinsDisplayPauseMenu.fontColor = SKColor.white
            
            coinsDisplayPauseMenu.text = "\(formatNumber(playerCoins!))"
            coinsDisplayPauseMenu.position = CGPoint(x: -(self.size.width * 0.8) * 0.04, y: -self.size.height * 0.22)
            coinsDisplayPauseMenu.zPosition = 1005
            pauseMenu?.addChild(coinsDisplayPauseMenu)
            
            heartsDisplayPauseMenu.text = "\(playerHealth ?? 0)"
            heartsDisplayPauseMenu.fontName = "Futura-Bold"
            heartsDisplayPauseMenu.fontSize = 16
            heartsDisplayPauseMenu.fontColor = SKColor.white
            heartsDisplayPauseMenu.zPosition = 1005
            heartsDisplayPauseMenu.position = CGPoint(x: (self.size.width * 0.8) * 0.13, y: -self.size.height * 0.22)
            pauseMenu?.addChild(heartsDisplayPauseMenu)
            
            // Add the pause menu to the scene
            addChild(pauseMenu!)
            print("Pause menu added")
        }
    }
    
    func resetLevel() {
        if let currentScene = self.scene {
            let newScene = type(of: currentScene).init(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: transition)
        }
    }
    
    func showAd() {
        if let viewController = self.view?.window?.rootViewController {
            rewardedViewModel.rewardedAd?.present(fromRootViewController: viewController) {
                // This block is called after the user finishes watching the ad
                let reward = self.rewardedViewModel.rewardedAd?.adReward
                print("User earned reward: \(reward?.amount ?? 0) \(reward?.type ?? "")")
                
                // Example: Grant a life or revive the player
                self.playerHealth += 1
                UserDefaults.standard.set(self.playerHealth, forKey: "playerHealth")
                self.displayHealthLabel.text = "\(self.playerHealth!)"
                
                self.lastHitTime = TimeInterval(CACurrentMediaTime())
                self.isInvincible = true
                
                // Resume the game or restart the level
                self.resumeGame()
            }
        } else {
            print("Root view controller is not available.")
        }
    }
    
    func resumeGame() {
        // Remove losing screen and resume game
        pauseOverlay?.removeFromParent()
        pauseOverlay = nil
        loseScreenWatchAdButton.removeFromParent()
        loseScreenQuitButton.removeFromParent()
        loseScreenRetryButton.removeFromParent()
        losingScreen.removeFromParent()

        
        // Unpause the game
        scene?.isPaused = false
    }
    
    // Function to toggle the pause state
    func togglePause() {
        if isGamePaused {
            // Unpause the game
            scene?.isPaused = false
            physicsWorld.speed = 1.0
            
            pauseOverlay?.isHidden = true
            pauseMenu?.isHidden = true
            pauseOverlay = nil
            pauseMenu = nil
        } else {
            // Pause the game
            setupPauseScreen()
            pauseOverlay?.isHidden = false
            pauseMenu?.isHidden = false
            scene?.isPaused = true
            physicsWorld.speed = 0
        }
        isGamePaused.toggle()
    }
    
    // Allowing options menu to appear and pause menu to be removed
    func setupOptionsMenu() {
        // Ensure pause menu and overlay are removed before displaying the settings menu
        pauseMenu?.removeFromParent()

        // If settingsMenu exists, remove it to prevent duplicate overlays
        settingsMenu?.removeFromParent()

        // Create the settings menu with a high zPosition
        settingsMenu = SKSpriteNode(imageNamed: "settings")
        settingsMenu?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        settingsMenu?.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        settingsMenu?.zPosition = 200  // Set high zPosition to ensure it’s on top

        // Add the settings menu to the scene
        if let settingsMenu = settingsMenu {
            addChild(settingsMenu)
        }
    }
    
//  Used to spawn asteroids 
    func startSpawningAsteroids() {
        // Remove any existing spawn asteroid actions
        removeAction(forKey: "spawningAsteroids")

        // Create a new spawn action with the updated speedMultiplier
        let spawnAsteroidsAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: (1.0 / Double(speedMultiplier)) / (0.1154 * Double(currentLevel) + 0.3846)),  // Adjust spawn frequency
            SKAction.run {
                createAsteroid(scene: self, screenSize: self.size, speedMultiplier: self.speedMultiplier, enemyCategory: self.enemyObjectCategory, playerCategory: self.playerObjectCategory, playerBullet: self.yellowBallCategory, coinValue: 1, pointValue: 1)
            }
        ]))

        // Run the new spawn action
        run(spawnAsteroidsAction, withKey: "spawningAsteroids")
    }
    
//  Used to spawn enemies that go up and down randomly
func startCreatingPersistentEnemies() {
    removeAction(forKey: "spawningPersistentEnemies")
    let spawnPersistentAction = SKAction.repeatForever(SKAction.sequence([
        SKAction.wait(forDuration: (5.0 / Double(speedMultiplier)) / (0.1154 * Double(currentLevel) + 0.3846)),
        SKAction.run {
            createPersistentEnemy(scene: self, screenSize: self.size, playerNode: self.circularSprite, speedMultiplier: self.speedMultiplier, enemyCategory: self.enemyObjectCategory, playerCategory: self.playerObjectCategory, playerBulletCategory: self.yellowBallCategory, coinValue: 3, pointValue: 3)
        }]))
    
    run(spawnPersistentAction, withKey: "spawningPersistentEnemies")
    
}
    
func startCreatingSatellites(){
    removeAction(forKey: "spawningSatellites")
    let spawnSatellitesAction = SKAction.repeatForever(SKAction.sequence([
        SKAction.wait(forDuration: (5.0 / Double(speedMultiplier)) / (0.1154 * Double(currentLevel) + 0.3846)),
        SKAction.run {
            createSatelliteWithLaser(scene: self, screenSize: self.size, speedMultiplier: self.speedMultiplier, enemyCategory: self.enemyObjectCategory, playerCategory: self.playerObjectCategory, playerBullet: self.yellowBallCategory, coinValue: 4, pointValue: 4)
        }]))
                                                                         
    run(spawnSatellitesAction, withKey: "spawningSatellites")
}

    
//  Used to spawn new enemies
    
    func startSpawningEnemies() {
        // Remove any existing spawn enemy actions
        removeAction(forKey: "spawningEnemies")

        // Create a new spawn action with the updated speedMultiplier
        let spawnEnemiesAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: (2.0 / Double(speedMultiplier)) / (0.1154 * Double(currentLevel) + 0.3846)),  // Adjust spawn frequency based on speedMultiplier
            SKAction.run {
                createFollowingEnemy(
                    scene: self,
                    screenSize: self.size,
                    playerNode: self.circularSprite,  // Assuming you have a playerNode defined
                    speedMultiplier: self.speedMultiplier,
                    enemyCategory: self.enemyObjectCategory,
                    playerCategory: self.playerObjectCategory,
                    playerBulletCategory: self.yellowBallCategory,
                    coinValue: 2,
                    pointValue: 2
                )
            }
        ]))

        // Run the new spawn action
        run(spawnEnemiesAction, withKey: "spawningEnemies")
    }
    
    // Function used to add all progress nodes
    func setupProgress() {
        
//      Progress bar holder 
        holderProgress = SKSpriteNode(imageNamed: "holderProgress")
        holderProgress.position = CGPoint(x: size.width / 2, y: size.height - 30 - adjustmentFactor)
        holderProgress.size = CGSize(width: self.size.width * 0.3, height: 8)
        addChild(holderProgress)
        
//      Ship that will move to demonstrate progress
        shipForProgress = SKSpriteNode(imageNamed: "shipForProgress")
        shipForProgress.position = CGPoint(x: self.size.width * 0.35, y: size.height - 30 - adjustmentFactor)
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
        endLevelIcon.position = CGPoint(x: self.size.width * 0.65, y: size.height - 30 - adjustmentFactor)
        endLevelIcon.zPosition = 3
        endLevelIcon.size = CGSize(width: 30, height: 30)
        addChild(endLevelIcon)
        
    }
    
    //  Function that moves the ship to the right
    func moveShip() {
        // Move the ship to the right by `shipSpeed`
        shipForProgress.position.x += (shipSpeed * speedMultiplier / (1500 / self.size.width))
        
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
        
        let livesRemaining = UserDefaults.standard.set(playerHealth, forKey: "livesRemaining")
        
        let victory = SKAction.playSoundFileNamed("victory.mp3", waitForCompletion: false)
        
        self.run(victory)
        
        // Check if the current level is higher than the saved `highestCompletedLevel`
        if currentLevel > highestCompletedLevel {
            // Update `highestCompletedLevel` in UserDefaults
            UserDefaults.standard.set(currentLevel, forKey: "highestCompletedLevel")
            transitionToLevelCompleteScene()
        }
        else {
            transitionToLevelCompleteScene()
        }
        
    }
    
    // Function to add the movement bar and movement knob
    func addMovementBar() {
        // Add movement bar at the bottom of the screen
        movementBar = SKSpriteNode(imageNamed: "MovementController")
        movementBar.size = CGSize(width: 313 / 5, height: 1190 / 5)
        movementBar.position = CGPoint(x: 70, y: size.height / 2 - 30)
        movementBar.zPosition = 100
        addChild(movementBar)

        // Add movement knob on top of the movement bar
        movementKnob = SKSpriteNode(imageNamed: "MovementKnob")
        movementKnob.size = CGSize(width: 405 / 5 , height: 405 / 5)
        movementKnob.position = movementBar.position
        movementKnob.zPosition = 100
        addChild(movementKnob)
    }
    
    //  Sends player back to levels scene
    func transitionToLevelsScene() {
        let levelsScene = NewLevelsScreen(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(levelsScene, transition: transition)
    }
    
    func transitionToLevelCompleteScene() {
        let levelComplete = LevelComplete(size: size)
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(levelComplete, transition: transition)
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
        circularSprite = SKSpriteNode(imageNamed: "new_ship")
        
        circularSprite.size = CGSize(width: 150, height: 52)
        circularSprite.position = CGPoint(x: 180, y: self.size.height / 2)
        
//      Adjustment factor
        let physicsBodySize = CGSize(width: circularSprite.size.width * 0.1, height: circularSprite.size.height * 0.1)
        
        // Add physics body to blue ball
        circularSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        circularSprite.physicsBody?.isDynamic = true
        circularSprite.physicsBody?.categoryBitMask = playerObjectCategory
        circularSprite.physicsBody?.contactTestBitMask = enemyObjectCategory
        circularSprite.physicsBody?.collisionBitMask = 0
        circularSprite.physicsBody?.affectedByGravity = false
        
        addChild(circularSprite)
    }
    
    // Function to spawn a bouncing red ball
//    func spawnRedBall() {
//        redBall = SKShapeNode(circleOfRadius: 20)
//        redBall.fillColor = .red
//        redBall.strokeColor = .white
//        redBall.lineWidth = 5
//        
//        // Position randomly on the screen
//        let randomX = CGFloat.random(in: 100...self.size.width - 100)
//        let randomY = CGFloat.random(in: 100...self.size.height - 100)
//        redBall.position = CGPoint(x: self.size.width - 50, y: randomY)
//        
//        // Add physics body to red ball
//        redBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//        redBall.physicsBody?.isDynamic = true
//        redBall.physicsBody?.categoryBitMask = enemyObjectCategory
//        redBall.physicsBody?.contactTestBitMask = playerObjectCategory | yellowBallCategory
//        redBall.physicsBody?.collisionBitMask = playerObjectCategory
//        redBall.physicsBody?.restitution = 1.0  // Make the ball bouncy
//        redBall.physicsBody?.linearDamping = 0  // No friction on the ball
//        redBall.physicsBody?.angularDamping = 0
//        redBall.physicsBody?.friction = 0
//        redBall.physicsBody?.affectedByGravity = false
//        
//        // Add an initial random velocity
//        let randomVelocity = CGVector(
//            dx: CGFloat.random(in: (-200)...(-100)),  // Always move left (negative dx)
//            dy: CGFloat.random(in: -200...200)    // Randomize vertical movement
//        )
//        redBall.physicsBody?.velocity = randomVelocity
//        
//        addChild(redBall)
//    }
    
    // Function to fire lazer from player
    func fireYellowBall() {
        let yellowBall = SKSpriteNode(imageNamed: "playerlaser")
        
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
        yellowBall.physicsBody?.velocity = CGVector(dx: 300 * speedMultiplier, dy: 0)
        
        // Add yellow ball (laser) to the scene
        addChild(yellowBall)
        
        let currentTime = CACurrentMediaTime()

        // Check if the time elapsed since the last shot is greater than or equal to the specified interval
        if currentTime - timeSincePlayerShotSound >= howOftenPlayerShotSound {
            self.run(SKAction.playSoundFileNamed("lazer_noise.mp3", waitForCompletion: false))
            timeSincePlayerShotSound = currentTime  // Update the last shot time to the current time
        }
        // Action to remove yellow ball when it goes off-screen
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: 5.0), SKAction.removeFromParent()])
        yellowBall.run(removeAction)
    }
    
//    Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // First, get the touch location relative to the scene
            let location = touch.location(in: self)

            // Handle movement knob touches
            if movementKnob.contains(location) {
                isMovementKnobActive = true
            }

            // Handle speed knob touches
            if speedKnob.contains(location) {
                isSpeedBarMoving = true
            }
            
            if loseScreenQuitButton.contains(location) {
                transitionToLevelsScene()
            }
            
            if loseScreenRetryButton.contains(location) {
                resetLevel()
            }
            
            if loseScreenWatchAdButton.contains(location){
                showAd()
            }

            // Check for pause state: Handle resume and pause buttons
            if isGamePaused {
                
                // If the game is paused, check for the resume button in the pause menu's coordinate space
                if let pauseMenu = pauseMenu {  // Ensure pauseMenu is not nil
                    let pauseMenuLocation = touch.location(in: pauseMenu)  // Get touch location in pauseMenu's coordinate space
                    if resumeButton.contains(pauseMenuLocation) {
                        togglePause()  // Resume the game
                    }
                    
                    if quitButton.contains(pauseMenuLocation) {
                        transitionToLevelsScene() // Quits level
                    }
                    if resetButton.contains(pauseMenuLocation){
                        resetLevel()
                    }
                    
                }
                
            } else {
                // If the game is not paused, check for the pause button in the scene's coordinate space
                if pauseButton.contains(location) {
                    togglePause()  // Pause the game
                }
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
                speedBar.zPosition = 50

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
                speedShipBar.zPosition = 30

                // Calculate the position ratio (0.0 on the left, 1.0 on the right)
                let positionRatio = (newXPosition - minX) / (maxX - minX)
                
                // Determines the speedValue based on how far speed is moved left or right
                let speedValue = 0.5 + (positionRatio * (maxSpeedValue - 0.5))
                
                // Save the speedValue to UserDefaults
                UserDefaults.standard.set(speedValue, forKey: "speedBarValue")
                
                speedMultiplier = CGFloat(speedValue)

                startFiringBullets()
                startSpawningAsteroids()
                startSpawningEnemies()
                
                if currentLevel >= 3 {
                    startCreatingPersistentEnemies()
                }
                
                if currentLevel >= 9 {
                    startCreatingSatellites()
                }
                
                // Define the two RGBA colors
                let startColor = (r: CGFloat(0), g: CGFloat(171), b: CGFloat(255), a: CGFloat(0.56))
                let endColor = (r: CGFloat(255), g: CGFloat(61), b: CGFloat(0), a: CGFloat(0.56))

                // Interpolate between the start and end colors based on the knob's position
                let r = interpolate(from: startColor.r, to: endColor.r, progress: positionRatio)
                let g = interpolate(from: startColor.g, to: endColor.g, progress: positionRatio)
                let b = interpolate(from: startColor.b, to: endColor.b, progress: positionRatio)
                let a = interpolate(from: startColor.a, to: endColor.a, progress: positionRatio)

                // Update the knob's color with the interpolated values
                speedKnob.fillColor = UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
                speedKnob.zPosition = 1000
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
        
        startFiringBullets()
        startSpawningAsteroids()
        startSpawningEnemies()
        
        if currentLevel >= 3 {
            startCreatingPersistentEnemies()
        }
        
        if currentLevel >= 9 {
            startCreatingSatellites()
        }
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Also reset the knob if the touch is canceled
        resetMovementKnobPosition()
        isJoystickActive = false
        isSpeedBarMoving = false
        
        startFiringBullets()
        startSpawningAsteroids()
        startSpawningEnemies()
        
        if currentLevel >= 3 {
            startCreatingPersistentEnemies()
        }
        
        if currentLevel >= 9 {
            startCreatingSatellites()
        }
    }
    
    // MARK: - Update Cycle
    override func update(_ currentTime: TimeInterval) {
        // Move both backgrounds to the left
        background1.position.x -= 2 * speedMultiplier  // Adjust this speed as needed
        background2.position.x -= 2 * speedMultiplier
        
        // Allows for iFrames
        if currentTime - lastHitTime < iFrameDuration {
            isInvincible = true
        } else {
            isInvincible = false
        }
        
        // Keeps user from hearing shots too rapidly
        if timeSincePlayerShotSound > howOftenPlayerShotSound {
            shouldSoundShot = true
        } else {
            shouldSoundShot = false
        }
        
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
    
    func handle_player_death() {
        
        pauseOverlay = SKSpriteNode(color: SKColor(red: 0, green: 0, blue: 0, alpha: 0.6), size: self.size)
        pauseOverlay?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        pauseOverlay?.zPosition = 95
        addChild(pauseOverlay!)
        
        losingScreen = SKSpriteNode(imageNamed: "losing_screen")
        losingScreen.size = CGSize(width: self.size.width * 1, height: self.size.height * 1)
        losingScreen.zPosition = 200
        losingScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(losingScreen)
        
        loseScreenRetryButton = SKShapeNode(circleOfRadius: self.size.width * 0.047)
        loseScreenRetryButton.fillColor = SKColor.clear
        loseScreenRetryButton.strokeColor = SKColor.clear
        loseScreenRetryButton.zPosition = 201
        loseScreenRetryButton.position = CGPoint(x: self.size.width * 0.42, y: self.size.height * 0.19)
        addChild(loseScreenRetryButton)
        
        // Must be on top of losing screen
        loseScreenQuitButton = SKShapeNode(circleOfRadius: self.size.width * 0.047)
        loseScreenQuitButton.fillColor = SKColor.clear
        loseScreenQuitButton.strokeColor = SKColor.clear
        loseScreenQuitButton.zPosition = 201
        loseScreenQuitButton.position = CGPoint(x: self.size.width * 0.5693, y: self.size.height * 0.19)
        addChild(loseScreenQuitButton)
        
        loseScreenWatchAdButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.37, height: self.size.height * 0.15))
        loseScreenWatchAdButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.4)
        loseScreenWatchAdButton.zPosition = 203
        loseScreenWatchAdButton.strokeColor = SKColor.clear
        loseScreenWatchAdButton.fillColor = SKColor.clear
        addChild(loseScreenWatchAdButton)
        
        scene?.isPaused = true
    }
    
    // MARK: - Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node

        // Detect collisions between player (blueBall) and enemy objects (e.g., asteroids)
        if (bodyA?.physicsBody?.categoryBitMask == playerObjectCategory && bodyB?.physicsBody?.categoryBitMask == enemyObjectCategory) && isInvincible == false ||
            (bodyA?.physicsBody?.categoryBitMask == enemyObjectCategory && bodyB?.physicsBody?.categoryBitMask == playerObjectCategory && isInvincible == false) {

            playerHealth -= 1
            UserDefaults.standard.set(playerHealth, forKey: "playerHealth")
            
            // player has now been hit more recently
            lastHitTime = TimeInterval(CACurrentMediaTime())
            
            // Sound of player being hit
            let playDamageAction = SKAction.playSoundFileNamed("Take-Damage-player.mp3", waitForCompletion: false)
            
            self.run(playDamageAction)
            
            
            playerUnhit = false
            UserDefaults.standard.set(playerUnhit, forKey: "playerUnhit")
            
//          player has died
            if playerHealth <= 0 {
                
                handle_player_death()
//                transitionToLevelsScene()
            }
            displayHealthLabel.text = "\(playerHealth!)"

            print("Player collided with an enemy!")
        }

        // Detect collisions between lazer and enemy objects (e.g., asteroids)
        if (bodyA?.physicsBody?.categoryBitMask == yellowBallCategory && bodyB?.physicsBody?.categoryBitMask == enemyObjectCategory) ||
           (bodyA?.physicsBody?.categoryBitMask == enemyObjectCategory && bodyB?.physicsBody?.categoryBitMask == yellowBallCategory) {
            bodyA?.removeFromParent()
            bodyB?.removeFromParent()
            
            // Identify which is the enemy
            let enemy = bodyA?.physicsBody?.categoryBitMask == enemyObjectCategory ? bodyA : bodyB

            // Retrieve the coinValue from the asteroid's userData
            if let coinValue = enemy?.userData?["coinValue"] as? Int {
                playerCoins += coinValue * Int(coinMultiplier)
                UserDefaults.standard.set(playerCoins, forKey: "playerCoins")
            }
            
            if let pointValue = enemy?.userData?["pointValue"] as? Int {
                playerScore += pointValue * Int(scoreMultiplier)
                UserDefaults.standard.set(playerScore, forKey: "playerScore")
            }
            
            coinLabel.text = "\(formatNumber(playerCoins!))"
            
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
    
    func formatNumber(_ number: Int) -> String {
        switch number {
        case 1_000_000_000...:
            return "\(number / 1_000_000_000)b"  // Billion
        case 1_000_000...:
            return "\(number / 1_000_000)m"  // Million
        case 1_000...:
            return "\(number / 1_000)k"  // Thousand
        default:
            return "\(number)"  // Default
        }
    }
}
