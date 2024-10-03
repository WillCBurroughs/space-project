//
//  Levels.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

class Levels: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Create a spiral of level buttons
        let numberOfLevels = 25  // Number of levels you want to display
        createEvenlySpacedLevelsInGrid(numberOfLevels: numberOfLevels, rows: 5, columns: 5)
    }
    
    
    func createEvenlySpacedLevelsInGrid(numberOfLevels: Int, rows: Int, columns: Int) {
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
                levelButton.fillColor = .green
                levelButton.strokeColor = .black
                levelButton.lineWidth = 2
                
                // Enable user interaction and name each node
                levelButton.isUserInteractionEnabled = false
                levelButton.name = "level\(currentLevel)"
                
                // Add a label with the level number inside the button
                let label = SKLabelNode(text: "\(currentLevel)")
                label.fontName = "Arial-BoldMT"
                label.fontSize = 20
                label.fontColor = .white
                label.verticalAlignmentMode = .center
                levelButton.addChild(label)
                
                // Add the button to the scene
                addChild(levelButton)
                
                currentLevel += 1
            }
        }
    }
}
