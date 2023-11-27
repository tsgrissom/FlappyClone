//
//  MainMenuViewController.swift
//  FlappyClone
//
//  Created by Tyler Grissom on 11/26/23.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
