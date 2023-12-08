import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private let defaults = UserDefaults.standard
    
    private func ensureUserDefaults() {
        // Game Difficulty
        if defaults.object(forKey: DefaultsKey.DieOnOutOfBounds) == nil {
            defaults.setValue(true, forKey: DefaultsKey.DieOnOutOfBounds)
        }
        if defaults.object(forKey: DefaultsKey.DieOnHitBoundary) == nil {
            defaults.setValue(false, forKey: DefaultsKey.DieOnHitBoundary)
        }
        if defaults.object(forKey: DefaultsKey.DieOnHitWall) == nil {
            defaults.setValue(false, forKey: DefaultsKey.DieOnHitWall)
        }
        if defaults.object(forKey: DefaultsKey.NumberOfWallHitsAllowed) == nil {
            defaults.setValue(0, forKey: DefaultsKey.NumberOfWallHitsAllowed)
        }
        
        // Game Data
        if defaults.object(forKey: DefaultsKey.HighScore) == nil {
            defaults.setValue(0, forKey: DefaultsKey.HighScore)
        }
        
        // App Settings
        if defaults.object(forKey: DefaultsKey.AudioMuted) == nil {
            defaults.setValue(false, forKey: DefaultsKey.AudioMuted)
        }
        if defaults.object(forKey: DefaultsKey.GamepadDisplayMode) == nil {
            defaults.setValue("Dynamic", forKey: DefaultsKey.GamepadDisplayMode)
        }
        if defaults.object(forKey: DefaultsKey.HapticsDisabled) == nil {
            defaults.setValue(false, forKey: DefaultsKey.HapticsDisabled)
        }
        if defaults.object(forKey: DefaultsKey.PreferredGamepad) == nil {
            defaults.setValue("Dynamic", forKey: DefaultsKey.PreferredGamepad)
        }
        if defaults.object(forKey: DefaultsKey.PreferredSceneSetting) == nil {
            defaults.setValue("Random", forKey: DefaultsKey.PreferredSceneSetting)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ensureUserDefaults()
        
        if let view = self.view as! SKView? {
            if let initialScene = SKScene(fileNamed: "MenuScene") {
                initialScene.scaleMode = .aspectFill
                view.presentScene(initialScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
