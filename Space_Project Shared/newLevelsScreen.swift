//
//  newLevelsScreen.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/8/24.
//

// Add background (Done)
// Add nodes on the top of every planet
// Add level logic to cover planets that are not unlocked
// Add reset button for resetting progress

import SpriteKit

class NewLevelsScreen: SKScene {
    
    // Array to hold all the touchable planets (levels)
    var levelNodes: [SKShapeNode] = []
    
    // This method will dynamically add SKShapeNodes on top of the planets
    override func didMove(to view: SKView) {
        
        // Add background image (level select image)
        let background = SKSpriteNode(imageNamed: "newLevelsDesign")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = self.size  // Adjust to fill the screen
        background.zPosition = -1  // Ensure background is behind other nodes
        addChild(background)
        
        let rowOneY = 0.55
        let rowTwoY = 0.20
        
        // Relative positions (x, y) for each planet as percentages of the background's size
        let relativePlanetPositions: [(CGFloat, CGFloat)] = [
            (0.12, rowOneY), // Planet 1
            (0.25, rowOneY), // Planet 2
            (0.37, rowOneY), // Planet 3
            (0.49, rowOneY), // Planet 4
            (0.61, rowOneY), // Planet 5
            (0.74, rowOneY), // Planet 6
            (0.87, rowOneY), // Planet 7
            (0.18, rowTwoY), // Planet 8
            (0.45, rowTwoY), // Planet 9
            (0.62, rowTwoY), // Planet 10
            (0.79, rowTwoY), // Planet 11
            (0.96, rowTwoY), // Planet 12
            (0.45, rowTwoY), // Planet 13
            (0.62, rowTwoY)  // Planet 14
        ]
        
        // Loop through each position and create an SKShapeNode for interaction
        for (index, relativePos) in relativePlanetPositions.enumerated() {
            let planetX = self.size.width * relativePos.0
            let planetY = self.size.height * relativePos.1
            
            let planetNode = SKShapeNode(circleOfRadius: self.size.width * 0.050)  // Adjust circle size dynamically
            planetNode.position = CGPoint(x: planetX, y: planetY)
            planetNode.strokeColor = .clear  // Set to clear or another color for debugging
            planetNode.fillColor = .white    // Set to clear, but can add transparency for debugging
            planetNode.name = "planet\(index + 1)"  // Set a unique name for each planet node
            planetNode.zPosition = 1  // Ensure it's above the background
            
            addChild(planetNode)
            levelNodes.append(planetNode)  // Store in the array for later use
        }
    }
    
    // Detect touches to interact with planets
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let nodeName = touchedNode.name, nodeName.starts(with: "planet") {
                let levelNumber = nodeName.replacingOccurrences(of: "planet", with: "")
                print("Tapped on planet for level \(levelNumber)")
                // Implement level selection logic here
                loadLevel(levelNumber: Int(levelNumber)!)
            }
        }
    }
    
    // Placeholder function to load the selected level
    func loadLevel(levelNumber: Int) {
        print("Loading level: \(levelNumber)")
        // Transition to the appropriate game scene here
    }
}

