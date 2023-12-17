import SpriteKit
import WatchKit

class GameScene: SKScene {
    
    private var background = SKSpriteNode()
    private var ground     = SKSpriteNode()
    private var clouds     = SKSpriteNode()
    private var player     = SKSpriteNode()
    
    private func createScene() {
        background = SKSpriteNode(imageNamed: "BG-Day")
        ground     = SKSpriteNode(imageNamed: "Clouds-Day")
        clouds     = SKSpriteNode(imageNamed: "Clouds-Day")
        player     = SKSpriteNode(imageNamed: "Birb")
        
        background.zPosition = 1
        player.zPosition = 2
        ground.zPosition = 3
        clouds.zPosition = 3
        clouds.zRotation = -CGFloat.pi
        
        ground.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        clouds.position = CGPoint(x: frame.midX, y: frame.midY + 125)
        
        addChild(background)
        addChild(ground)
        addChild(clouds)
        addChild(player)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        createScene()
    }
}
