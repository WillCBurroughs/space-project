//
//  TransitionHelper.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 10/2/24.
//

import SpriteKit

// Helper function for scene transitions
func transitionToScene(view: SKView?, scene: SKScene) {
    // Present the scene with the given transition
    let transition = SKTransition.fade(withDuration: 1.0)

    view?.presentScene(scene, transition: transition)
}
