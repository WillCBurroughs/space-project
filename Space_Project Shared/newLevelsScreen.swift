//
//  newLevelsScreen.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/8/24.
//

// Add background (Done)
// Add nodes on the top of every planet (Done)
// Add logic to pass in levels unlocked with popup (Done)
// Add level logic to cover planets that are not unlocked (Done)
// Add reset button for resetting progress 

import SpriteKit

class NewLevelsScreen: SKScene {
    
    var isPopupDisplayed = false  // Flag to prevent immediate popup dismissal
    
    let highestCompletedLevelKey = "highestCompletedLevel"  // Key for saving progress
    let selectedLevelKey = "selectedLevel"  // Key for saving selected level
    
    // Array to hold all the touchable planets (levels)
    var levelNodes: [SKShapeNode] = []
    
    let resetProgressButton = SKSpriteNode(imageNamed: "resetBlackhole")
    
    // Adding back button for main menu
    var backButton = SKSpriteNode(imageNamed: "backButton")
    
    var firstStar = SKSpriteNode()
    var secondStar = SKSpriteNode()
    var thirdStar = SKSpriteNode()
    
    
    var confirmReset = SKSpriteNode(imageNamed: "confirmReset")
    var confirmresetButton = SKShapeNode()
    var quitResetButton = SKShapeNode()
    
    
    override func didMove(to view: SKView) {
        
        backButton.name = "backButton"
        backButton.size = CGSize(width: self.size.width * 0.12, height: self.size.width * 0.12)
        backButton.zPosition = 50
        backButton.position = CGPoint(x: 100, y: self.size.height - 50)
        addChild(backButton)
        
        // Retrieve the highest completed level by the user
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
        
        // Add background image (level select image)
        let background = SKSpriteNode(imageNamed: "newLevelsDesign")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = self.size  // Adjust to fill the screen
        background.zPosition = -1  // Ensure background is behind other nodes
        addChild(background)
        
        resetProgressButton.position = CGPoint(x: size.width - 100, y: size.height - 50)
        resetProgressButton.size = CGSize(width: self.size.width * 0.1, height: self.size.width * 0.1)
        resetProgressButton.name = "resetProgress"
        addChild(resetProgressButton)
        
        let rowOneY = 0.55
        let rowTwoY = 0.25
        
        // Relative positions (x, y) for each planet as percentages of the background's size
        let relativePlanetPositions: [(CGFloat, CGFloat)] = [
            (0.125, rowOneY), // Planet 1
            (0.245, rowOneY), // Planet 2
            (0.37, rowOneY), // Planet 3
            (0.49, rowOneY), // Planet 4
            (0.615, rowOneY), // Planet 5
            (0.735, rowOneY), // Planet 6
            (0.870, rowOneY), // Planet 7
            (0.125, rowTwoY), // Planet 8
            (0.245, rowTwoY), // Planet 9
            (0.37, rowTwoY), // Planet 10
            (0.49, rowTwoY), // Planet 11
            (0.615, rowTwoY), // Planet 12
            (0.735, rowTwoY), // Planet 13
            (0.870, rowTwoY)  // Planet 14
        ]
        
        // Loop through each position and create either an SKShapeNode or SKSpriteNode
        for (index, relativePos) in relativePlanetPositions.enumerated() {
            let planetX = self.size.width * relativePos.0
            let planetY = self.size.height * relativePos.1
            
            if index <= highestCompletedLevel {  // Level is unlocked or the next one to be unlocked
                // Create an SKShapeNode (interactive)
                let planetNode = SKShapeNode(circleOfRadius: self.size.width * 0.050)  // Adjust circle size dynamically
                planetNode.position = CGPoint(x: planetX, y: planetY)
                planetNode.strokeColor = .clear
                planetNode.fillColor = .clear  // Transparent node
                planetNode.name = "planet\(index + 1)"  // unique name for each planet node
                planetNode.zPosition = 1  // Ensure it's above the background
                
                addChild(planetNode)
                levelNodes.append(planetNode)  // Store in the array for later use
                
            } else {  // Level is locked
                // Create an SKSpriteNode with the "locked" image
                let lockedNode = SKSpriteNode(imageNamed: "locked\(index + 1)")  // Use locked image based on index
                lockedNode.position = CGPoint(x: planetX, y: planetY)
                lockedNode.size = CGSize(width: self.size.width * 0.12, height: self.size.width * 0.12)  // Adjust size for locked image
                lockedNode.zPosition = 1
                
                addChild(lockedNode)
            }
        }
    }
    
    func createResetMenu(){
        confirmReset.size = CGSize(width: self.size.width, height: self.size.height)
        confirmReset.zPosition = 10
        confirmReset.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.6)
        addChild(confirmReset)
        
        confirmresetButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3, height: self.size.width * 0.06), cornerRadius: 10)
        confirmresetButton.fillColor = SKColor.clear
        confirmresetButton.strokeColor = SKColor.clear
        confirmresetButton.zPosition = 1001
        confirmresetButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.44)
        confirmresetButton.name = "confirmresetButton"
        addChild(confirmresetButton)
        
        quitResetButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3, height: self.size.width * 0.06), cornerRadius: 10)
        quitResetButton.fillColor = SKColor.clear
        quitResetButton.strokeColor = SKColor.clear
        quitResetButton.zPosition = 1001
        quitResetButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.28)
        quitResetButton.name = "quitResetButton"
        addChild(quitResetButton)
        
        
    }
    
    func removeResetProgressMenu() {
        
        confirmReset.removeFromParent()
        confirmresetButton.removeFromParent()
        quitResetButton.removeFromParent()
        
    }
    
    // Detect touches to interact with planets
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            // Check if the popup is already displayed
            if isPopupDisplayed {
                // Dismiss the popup if the tap was **outside** the popup
                if touchedNode.name != "popupBackground" && touchedNode.name != "playButton" && touchedNode.name != "playLabel" && touchedNode.name != "levelLabel" {
                    removePopup()
                }
                return
            }
            
            // If the node name starts with "planet" (unlocked level), handle level selection
            if let nodeName = touchedNode.name, nodeName.starts(with: "planet") {
                let levelNumber = nodeName.replacingOccurrences(of: "planet", with: "")
                if let levelNum = Int(levelNumber) {
                    let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
                    
                    // Only proceed if the level is unlocked
                    if levelNum <= highestCompletedLevel + 1 {
                        popUpStartLevel(levelSelected: levelNum)
                        isPopupDisplayed = true  // Set flag to true once popup is displayed
                    }
                }
            }
        }
    }
    
    // Handles touch interactions on the popup
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // Handle touch on the play button
        for node in nodesAtPoint {
            if node.name == "playButton" {
                let selectedLevel = UserDefaults.standard.integer(forKey: selectedLevelKey)
                startLevel(levelNumber: selectedLevel)  // Start the selected level
            }
            
            if node.name == "backButton" {
                transitionToMainMenu()
            }
            
            if node.name == "resetProgress" {
                createResetMenu()
            }
            
            if node.name == "confirmresetButton" {
                resetProgress()
            }
            
            if node.name == "quitResetButton" {
                removeResetProgressMenu()
            }
            
        }
        
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func transitionToMainMenu() {
        
        let menuScene = HomeScreen(size: self.size)
        menuScene.scaleMode = self.scaleMode
        
        // Transition to the main menu
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    // Function to remove the popup from the scene
    func removePopup() {
        if let popup = childNode(withName: "popupBackground") {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
            let removeAction = SKAction.removeFromParent()
            popup.run(SKAction.sequence([fadeOutAction, removeAction]))
            isPopupDisplayed = false  // Reset flag
            
            firstStar.removeFromParent()
            secondStar.removeFromParent()
            thirdStar.removeFromParent()
        }
    }
    
    // Function to load the selected level
    func loadLevel(levelNumber: Int) {
        print("Loading level: \(levelNumber)")
        startLevel(levelNumber: levelNumber)  // Start the selected level
    }
    
// function used for unbeaten level
    func create_zero_star_visual(){
        
        var star_size = 0.08
        var adjust_y = 0.43
        
        firstStar = SKSpriteNode(imageNamed: "silverStar")
        firstStar.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * adjust_y)
        firstStar.zPosition = 1000
        firstStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        firstStar.zRotation = 5 * (CGFloat.pi / 180)
        addChild(firstStar)
        
        secondStar = SKSpriteNode(imageNamed: "silverStar")
        secondStar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * (adjust_y + 0.03))
        secondStar.zPosition = 1000
        secondStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(secondStar)
        
        thirdStar = SKSpriteNode(imageNamed: "silverStar")
        thirdStar.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * adjust_y)
        thirdStar.zPosition = 1000
        thirdStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        thirdStar.zRotation = -5 * (CGFloat.pi / 180)
        addChild(thirdStar)
    }
    
//  below functions will be used to call gold stars on popup based on best performance
    func create_one_star_visual(){
        
        var star_size = 0.08
        var adjust_y = 0.43
        
        firstStar = SKSpriteNode(imageNamed: "goldStar")
        firstStar.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * adjust_y)
        firstStar.zPosition = 1000
        firstStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        firstStar.zRotation = 5 * (CGFloat.pi / 180)
        addChild(firstStar)
        
        secondStar = SKSpriteNode(imageNamed: "silverStar")
        secondStar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * (adjust_y + 0.03))
        secondStar.zPosition = 1000
        secondStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(secondStar)
        
        thirdStar = SKSpriteNode(imageNamed: "silverStar")
        thirdStar.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * adjust_y)
        thirdStar.zPosition = 1000
        thirdStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        thirdStar.zRotation = -5 * (CGFloat.pi / 180)
        addChild(thirdStar)
    }
    
    func create_two_star_visual(){
        
        var star_size = 0.08
        var adjust_y = 0.43
        
        firstStar = SKSpriteNode(imageNamed: "goldStar")
        firstStar.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * adjust_y)
        firstStar.zPosition = 1000
        firstStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        firstStar.zRotation = 5 * (CGFloat.pi / 180)
        addChild(firstStar)
        
        secondStar = SKSpriteNode(imageNamed: "goldStar")
        secondStar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * (adjust_y + 0.03))
        secondStar.zPosition = 1000
        secondStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(secondStar)
        
        thirdStar = SKSpriteNode(imageNamed: "silverStar")
        thirdStar.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * adjust_y)
        thirdStar.zPosition = 1000
        thirdStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        thirdStar.zRotation = -5 * (CGFloat.pi / 180)
        addChild(thirdStar)
    }
    
    func create_three_star_visual(){
        var star_size = 0.2
        var adjust_y = 0.43
        
        firstStar = SKSpriteNode(imageNamed: "purpleStar")
        firstStar.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * adjust_y)
        firstStar.zPosition = 1000
        firstStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        firstStar.zRotation = 5 * (CGFloat.pi / 180)
        addChild(firstStar)
        
        secondStar = SKSpriteNode(imageNamed: "purpleStar")
        secondStar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * (adjust_y + 0.03))
        secondStar.zPosition = 1000
        secondStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        addChild(secondStar)
        
        thirdStar = SKSpriteNode(imageNamed: "purpleStar")
        thirdStar.position = CGPoint(x: self.size.width * 0.6, y: self.size.height * adjust_y)
        thirdStar.zPosition = 1000
        thirdStar.size = CGSize(width: self.size.width * star_size, height: self.size.width * star_size)
        // Rotating by 5 degrees
        thirdStar.zRotation = -5 * (CGFloat.pi / 180)
        addChild(thirdStar)
    }
    
    // Function to display the popup for level selection
    func popUpStartLevel(levelSelected: Int) {
        // Set the selected level
        UserDefaults.standard.set(levelSelected, forKey: selectedLevelKey)
        var bestStarsEarnedLevel = UserDefaults.standard.integer(forKey: "bestStarsEarnedLevel\(levelSelected)")
        
//      Used to display stars to screen
        if bestStarsEarnedLevel == 0 {
            create_zero_star_visual()
        } else if bestStarsEarnedLevel == 1 {
            create_one_star_visual()
        } else if bestStarsEarnedLevel == 2 {
            create_two_star_visual()
        } else if bestStarsEarnedLevel == 3 {
            create_three_star_visual()
        }
        
        // Create a semi-transparent background for the popup
        let popupBackground = SKSpriteNode(imageNamed: "playLevelScreen")
        popupBackground.size = CGSize(width: self.size.width * 1, height: self.size.height * 1)
        popupBackground.alpha = 1 // Make it semi-transparent
        popupBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        popupBackground.zPosition = 100  // Ensure it appears on top of other nodes
        popupBackground.name = "popupBackground"
        
        // Add a label to show the selected level
        let levelLabel = SKLabelNode(text: "Level \(levelSelected)")
        levelLabel.fontName = "Arial-BoldMT"
        levelLabel.fontSize = 30
        levelLabel.fontColor = .black
        levelLabel.name = "levelLabel"
        levelLabel.position = CGPoint(x: 0, y: 40)  // Position it near the top of the popup
        popupBackground.addChild(levelLabel)
        
        // Create the play button
        let playButton = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.3, height: self.size.width * 0.05), cornerRadius: 10)
        playButton.fillColor = .clear
        playButton.strokeColor = .clear
        playButton.lineWidth = 3
        playButton.position = CGPoint(x: 0, y: self.size.height * -0.315)  // Position it below the level label
        playButton.name = "playButton"
        playButton.zPosition = 2
        popupBackground.addChild(playButton)
        
        let quitPopupButton = SKShapeNode(circleOfRadius: self.size.width * 0.04)
        quitPopupButton.fillColor = UIColor.clear
        quitPopupButton.strokeColor = UIColor.clear
        quitPopupButton.position = CGPoint(x: self.size.width * 0.30, y: self.size.height * 0.2)
        quitPopupButton.zPosition = 6
        popupBackground.addChild(quitPopupButton)
        
        
        // Add "Play" text on the play button
//        let playLabel = SKLabelNode(text: "Play")
//        playLabel.fontName = "Arial-BoldMT"
//        playLabel.fontSize = 20
//        playLabel.fontColor = .black
//        playLabel.verticalAlignmentMode = .center
//        playLabel.name = "playLabel"
//        playButton.addChild(playLabel)
        
        // Add the popup background (and its children) to the scene
        addChild(popupBackground)
    }
    
    // Function to transition to the selected level
    func startLevel(levelNumber: Int) {
        print("Starting level \(levelNumber)")
        
        // Create an instance of the GameScene
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        
        // Transition to the GameScene
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    // Function to reset game progress
    func resetProgress(){

        resetDefaults()
        
        // Reload the scene to update the level buttons
        let newScene = NewLevelsScreen(size: self.size)
        newScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(newScene, transition: transition)
    }
    
}
