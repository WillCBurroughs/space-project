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
    
    override func didMove(to view: SKView) {
        
        // Retrieve the highest completed level by the user
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
        
        // Add background image (level select image)
        let background = SKSpriteNode(imageNamed: "newLevelsDesign")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = self.size  // Adjust to fill the screen
        background.zPosition = -1  // Ensure background is behind other nodes
        addChild(background)
        
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
            (0.865, rowOneY), // Planet 7
            (0.125, rowTwoY), // Planet 8
            (0.245, rowTwoY), // Planet 9
            (0.37, rowTwoY), // Planet 10
            (0.49, rowTwoY), // Planet 11
            (0.615, rowTwoY), // Planet 12
            (0.735, rowTwoY), // Planet 13
            (0.865, rowTwoY)  // Planet 14
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
        }
    }
    
    // Function to remove the popup from the scene
    func removePopup() {
        if let popup = childNode(withName: "popupBackground") {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
            let removeAction = SKAction.removeFromParent()
            popup.run(SKAction.sequence([fadeOutAction, removeAction]))
            isPopupDisplayed = false  // Reset flag
        }
    }
    
    // Function to load the selected level
    func loadLevel(levelNumber: Int) {
        print("Loading level: \(levelNumber)")
        startLevel(levelNumber: levelNumber)  // Start the selected level
    }
    
    // Function to display the popup for level selection
    func popUpStartLevel(levelSelected: Int) {
        // Set the selected level
        UserDefaults.standard.set(levelSelected, forKey: selectedLevelKey)
        
        // Create a semi-transparent background for the popup
        let popupBackground = SKShapeNode(rectOf: CGSize(width: 300, height: 200), cornerRadius: 20)
        popupBackground.fillColor = .white
        popupBackground.alpha = 0.8  // Make it semi-transparent
        popupBackground.strokeColor = .black
        popupBackground.lineWidth = 4
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
        let playButton = SKShapeNode(rectOf: CGSize(width: 100, height: 50), cornerRadius: 10)
        playButton.fillColor = .green
        playButton.strokeColor = .black
        playButton.lineWidth = 3
        playButton.position = CGPoint(x: 0, y: -30)  // Position it below the level label
        playButton.name = "playButton"
        playButton.zPosition = 2
        popupBackground.addChild(playButton)
        
        // Add "Play" text on the play button
        let playLabel = SKLabelNode(text: "Play")
        playLabel.fontName = "Arial-BoldMT"
        playLabel.fontSize = 20
        playLabel.fontColor = .black
        playLabel.verticalAlignmentMode = .center
        playLabel.name = "playLabel"
        playButton.addChild(playLabel)
        
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
}
