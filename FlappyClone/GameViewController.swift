import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
//            let menuScene = MenuScene(size: view.bounds.size)
//            menuScene.scaleMode = .aspectFill
//            view.presentScene(menuScene)
            if let gameScene = SKScene(fileNamed: "GameScene") {
                gameScene.scaleMode = .aspectFill
                view.presentScene(gameScene)
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
