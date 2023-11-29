import SpriteKit

class PlayButton: SKSpriteNode {
    
    private let scaleSize: Double
    
    private var textureNormal  = SKTexture(imageNamed: "BtnPlay")
    private var texturePressed = SKTexture(imageNamed: "BtnPlay-Pressed")
    
    var onPress = SKAction()
    
    init(scaleSize: Double = 1.0) {
        self.scaleSize = scaleSize
        super.init(texture: textureNormal, color: .clear, size: CGSize(width: 100, height: 100))
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.scaleSize = 1.0
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        let sideLength = 200 * scaleSize
        size = CGSize(width: sideLength, height: sideLength)

        let switchTextureToPressed = SKAction.setTexture(texturePressed)
        let delay = SKAction.wait(forDuration: 0.75)
        let returnTextureToNormal  = SKAction.setTexture(textureNormal)
        onPress = SKAction.sequence([
            switchTextureToPressed,
            delay,
            returnTextureToNormal
        ])
    }
}
