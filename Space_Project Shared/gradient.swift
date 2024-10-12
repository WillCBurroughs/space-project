//
//  gradient.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/12/24.
//

import SpriteKit
import UIKit

// Function to generate gradient texture with rounded corners
func createRoundedGradientTexture(size: CGSize, cornerRadius: CGFloat) -> SKTexture {
    // Create a UIGraphics context
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let image = renderer.image { context in
        // Create the rounded rectangle path
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        
        // Clip to the rounded rectangle
        path.addClip()
        
        // Create the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        
        // Set the gradient colors (from left to right)
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 171/255, blue: 255/255, alpha: 0.26).cgColor,  // RGBA(0, 171, 255, 0.26)
            UIColor(red: 255/255, green: 76/255, blue: 0/255, alpha: 0.26).cgColor    // RGBA(255, 76, 0, 0.26)
        ]
        
        // Set the gradient direction (left to right)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient into the current context
        gradientLayer.render(in: context.cgContext)
    }
    
    // Convert the UIImage to an SKTexture
    return SKTexture(image: image)
}

// Applying the rounded gradient texture to the speedShipBar
func applyRoundedGradientToSpeedShipBar(speedShipBar: SKSpriteNode, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
    // Create the gradient texture with rounded corners
    let gradientTexture = createRoundedGradientTexture(size: CGSize(width: width, height: height), cornerRadius: cornerRadius)
    
    // Apply the gradient texture to the speedShipBar
    speedShipBar.texture = gradientTexture
    speedShipBar.size = CGSize(width: width, height: height)
}
