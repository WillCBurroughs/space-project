//
//  Levels.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class Levels: SKScene {

    let highestCompletedLevelKey = "highestCompletedLevel"  // Key for saving progress
    let selectedLevelKey = "selectedLevel"  // Key for saving selected level

    let resetProgressButton = SKShapeNode(circleOfRadius: 30)  // Used to set all values back to zero
    var isPopupDisplayed = false  // Flag to prevent immediate popup dismissal

    override func didMove(to view: SKView) {
        backgroundColor = .white

        // Retrieve the highest completed level from UserDefaults
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)

        resetProgressButton.position = CGPoint(x: size.width - 70, y: size.height - 50)
        resetProgressButton.fillColor = .black
        resetProgressButton.strokeColor = .darkGray
        resetProgressButton.name = "resetProgress"
        addChild(resetProgressButton)

        // Create a grid of level buttons
        let numberOfLevels = 20  // Number of levels you want to display
        createEvenlySpacedLevelsInGrid(numberOfLevels: numberOfLevels, highestCompletedLevel: highestCompletedLevel, rows: 4, columns: 5)
    }

    func createEvenlySpacedLevelsInGrid(numberOfLevels: Int, highestCompletedLevel: Int, rows: Int, columns: Int) {
        let levelRadius: CGFloat = 30
        let horizontalSpacing: CGFloat = 20
        let verticalSpacing: CGFloat = 20

        let totalWidth = (levelRadius * 2 + horizontalSpacing) * CGFloat(columns) - horizontalSpacing
        let totalHeight = (levelRadius * 2 + verticalSpacing) * CGFloat(rows) - verticalSpacing

        let startX = (size.width - totalWidth) / 2 + levelRadius
        let startY = (size.height - totalHeight) / 2 + levelRadius

        var currentLevel = 1

        for row in 0..<rows {
            for col in 0..<columns {
                if currentLevel > numberOfLevels { break }

                let xPosition = startX + CGFloat(col) * (levelRadius * 2 + horizontalSpacing)
                let yPosition = startY + CGFloat(row) * (levelRadius * 2 + verticalSpacing)

                // Create level button (SKShapeNode)
                let levelButton = SKShapeNode(circleOfRadius: levelRadius)
                levelButton.position = CGPoint(x: xPosition, y: yPosition)
                levelButton.strokeColor = .black
                levelButton.lineWidth = 2
                levelButton.name = "level\(currentLevel)"  // Assign name for interaction

                // Check if the level is unlocked
                if currentLevel <= highestCompletedLevel + 1 {
                    // Unlocked: black button with white text
                    levelButton.fillColor = .black
                } else {
                    // Locked: gray button with gray text
                    levelButton.fillColor = .gray
                }

                // Add a label with the level number inside the button
                let label = SKLabelNode(text: "\(currentLevel)")
                label.fontName = "Arial-BoldMT"
                label.fontSize = 20
                label.fontColor = currentLevel <= highestCompletedLevel + 1 ? .white : .darkGray
                label.verticalAlignmentMode = .center
                levelButton.addChild(label)

                // Add the button to the scene
                addChild(levelButton)

                currentLevel += 1
            }
        }
    }

    // Handling touch events for levels
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        // If the popup is already displayed, handle dismiss or play button
        if isPopupDisplayed {
            var tappedOnPopup = false  // Track if the tap was on the popup or not

            for node in nodesAtPoint {
                if node.name == "popupBackground" || node.name == "playButton" {
                    tappedOnPopup = true
                }

                if node.name == "playButton" {
                    // Handle the "Play" button tap
                    let selectedLevel = UserDefaults.standard.integer(forKey: selectedLevelKey)
                    transitionToLevel(levelNumber: selectedLevel)
                }
            }

            // If the tap was not on the popup, remove the popup from the scene
            if !tappedOnPopup {
                if let popup = childNode(withName: "popupBackground") {
                    // Fade out the popup and remove it from the scene
                    let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
                    let removeAction = SKAction.removeFromParent()
                    popup.run(SKAction.sequence([fadeOutAction, removeAction]))
                    isPopupDisplayed = false  // Reset flag after dismissing popup
                }
            }

            return  // Exit early to prevent any further touch processing
        }

        // Handle the rest of the touch events (e.g., level selection)
        for node in nodesAtPoint {
            if let levelName = node.name, levelName.starts(with: "level") {
                // Extract the level number
                if let levelNumber = Int(levelName.replacingOccurrences(of: "level", with: "")) {
                    let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)

                    if levelNumber <= highestCompletedLevel + 1 {
                        // Level is unlocked, display popup
                        popUpStartLevel(levelSelected: levelNumber)
                        isPopupDisplayed = true  // Set flag to true once popup is displayed
                    }
                }
            }

            if node.name == "resetProgress" {
                resetProgress()
            }
        }
    }

    func popUpStartLevel(levelSelected: Int) {
        // Sets the selected level for the user
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
        levelLabel.position = CGPoint(x: 0, y: 40)  // Position it near the top of the popup
        popupBackground.addChild(levelLabel)

        // Create the play button (SKShapeNode)
        let playButton = SKShapeNode(rectOf: CGSize(width: 100, height: 50), cornerRadius: 10)
        playButton.fillColor = .green
        playButton.strokeColor = .black
        playButton.lineWidth = 3
        playButton.position = CGPoint(x: 0, y: -30)  // Position it below the level label
        playButton.name = "playButton"  // Name it for interaction handling
        popupBackground.addChild(playButton)

        // Add "Play" text on the play button
        let playLabel = SKLabelNode(text: "Play")
        playLabel.fontName = "Arial-BoldMT"
        playLabel.fontSize = 20
        playLabel.fontColor = .black
        playLabel.verticalAlignmentMode = .center
        playButton.addChild(playLabel)

        // Add the popup background (and its children) to the scene
        addChild(popupBackground)
    }

    // Function to reset game progress
    func resetProgress(){
        UserDefaults.standard.set(0, forKey: highestCompletedLevelKey)

        // Reload the scene to update the level buttons
        let newScene = Levels(size: self.size)
        newScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(newScene, transition: transition)
    }

    // Function to transition to the selected level
    func transitionToLevel(levelNumber: Int) {
        print("Transitioning to level \(levelNumber)")
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
        
////        Current code that allows the levelNumber to shift
//        if levelNumber > highestCompletedLevel {
//            UserDefaults.standard.set(levelNumber, forKey: highestCompletedLevelKey)
//        }
    }
}
