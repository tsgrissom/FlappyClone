import SpriteKit

class PlayButton: SKSpriteNode {
    
    private let sizeMultiplier: Double
    
    private var textureNormal  = SKTexture()
    private var texturePressed = SKTexture()
    
    var onPress = SKAction()
    
    init(sizeMultiplier: Double = 1.0) {
        self.sizeMultiplier = sizeMultiplier
        super.init(imageNamed: "BtnPlay")
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sizeMultiplier = 1.0
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let sideLength = 100 * sizeMultiplier
        size = CGSize(width: sideLength, height: sideLength)
        
        textureNormal  = SKTexture(imageNamed: "BtnPlay")
        texturePressed = SKTexture(imageNamed: "BtnPlay-Pressed")
        
        let switchTextureToPressed = SKAction.setTexture(texturePressed)
        let delay = SKAction.wait(forDuration: 0.75)
        let returnTextureToNormal  = SKAction.setTexture(normalTexture!)
        onPress = SKAction.sequence([
            switchTextureToPressed,
            delay,
            returnTextureToNormal
        ])
    }
}
