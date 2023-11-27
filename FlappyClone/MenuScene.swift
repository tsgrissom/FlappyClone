import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var playButton     = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    
    private func createScene() {
        let background = SKSpriteNode(imageNamed: "BG-Day")
        
        background.scale(to: frame.size)
        background.zPosition = 1
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let frameHtHalved = frame.height / 2
        
        playButton = SKSpriteNode(imageNamed: "BtnPlay")
        playButton.size = CGSize(width: 100, height: 100)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + (frameHtHalved * 0.1))
        playButton.zPosition = 2
        
        settingsButton = SKSpriteNode(imageNamed: "BtnSettings")
        settingsButton.size = CGSize(width: 200, height: 100)
        settingsButton.position = CGPoint(x: frame.midX, y: frame.midY + (frameHtHalved * 0.4))
        settingsButton.zPosition = 2
        
        self.addChild(background)
        self.addChild(playButton)
        self.addChild(settingsButton)
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO
    }
}
