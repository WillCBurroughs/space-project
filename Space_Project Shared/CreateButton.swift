//
//  CreateButton.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

// Function to create a capsule-shaped button with text and an optional action for touch events
func createCapsuleButton(buttonNode: SKShapeNode, text: String, position: CGPoint, width: CGFloat, height: CGFloat, parent: SKNode, action: (() -> Void)?) {
    // Create the capsule shape
    buttonNode.path = UIBezierPath(roundedRect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), cornerRadius: height / 2).cgPath
    buttonNode.fillColor = .white
    buttonNode.strokeColor = .black
    buttonNode.lineWidth = 2
    buttonNode.position = position
    
    // Add the button to the parent node
    parent.addChild(buttonNode)
    
    // Create and add the label for the button
    let label = SKLabelNode(text: text)
    label.fontName = "Arial-BoldMT"
    label.fontSize = 30
    label.fontColor = .black
    label.verticalAlignmentMode = .center
    label.position = CGPoint(x: 0, y: 0)
    
    // Add the label to the button
    buttonNode.addChild(label)
    
    // Store the action in the button node's userData
    if let action = action {
        buttonNode.userData = ["action": action]
    }
}

extension SKScene {
    // Detect touches and execute the action
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Get the node at the touch location
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            // Check if the node is an SKShapeNode with a stored action
            if let buttonNode = node as? SKShapeNode, let action = buttonNode.userData?["action"] as? () -> Void {
                action()  // Execute the stored action
            }
        }
    }
}
