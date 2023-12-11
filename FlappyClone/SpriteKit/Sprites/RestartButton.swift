import SpriteKit

class RestartButton: SKSpriteNode {
    
    init() {
        super.init(imageNamed: "BtnRestart")
        super.init
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
