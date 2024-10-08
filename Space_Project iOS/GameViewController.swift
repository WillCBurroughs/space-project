//
//  GameViewController.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 9/30/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SplashScene programmatically
//        let splashScene = SplashScene(size: view.bounds.size)
        
        let splashScene = NewLevelsScreen(size: view.bounds.size)
        
        // Present the splash scene
        let skView = self.view as! SKView
        skView.presentScene(splashScene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
