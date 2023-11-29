import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    private func ensureUserDefaults() {
        if userDefaults.object(forKey: DefaultsKey.AudioMuted) == nil {
            userDefaults.setValue(false, forKey: DefaultsKey.AudioMuted)
        }
        
        if userDefaults.object(forKey: DefaultsKey.HighScore) == nil {
            userDefaults.setValue(0, forKey: DefaultsKey.HighScore)
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
