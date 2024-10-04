//
//  Levels.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class Levels: SKScene {
    
    let highestCompletedLevelKey = "highestCompletedLevel"  // Key for saving progress
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Retrieve the highest completed level from UserDefaults
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
        
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
        
        for node in nodesAtPoint {
            if let levelName = node.name, levelName.starts(with: "level") {
                // Extract the level number
                if let levelNumber = Int(levelName.replacingOccurrences(of: "level", with: "")) {
                    let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
                    
                    if levelNumber <= highestCompletedLevel + 1 {
                        // Level is unlocked, transition to it
                        transitionToLevel(levelNumber: levelNumber)
                    }
                }
            }
        }
    }
    
    // Function to transition to the selected level
    func transitionToLevel(levelNumber: Int) {
        // Code to transition to the level scene
        print("Transitioning to level \(levelNumber)")  // Placeholder
        // Save the highest level completed if this is the new highest
        let highestCompletedLevel = UserDefaults.standard.integer(forKey: highestCompletedLevelKey)
        if levelNumber > highestCompletedLevel {
            UserDefaults.standard.set(levelNumber, forKey: highestCompletedLevelKey)
        }
    }
}
