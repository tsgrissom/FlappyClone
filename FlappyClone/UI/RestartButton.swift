import SpriteKit

class RestartButton: SKSpriteNode {
    
    init(scaleSize: CGFloat = 1.0) {
        let texture      = SKTexture(imageNamed: "BtnRestart-NoBg")
        let scaledWidth  = 200 * scaleSize
        let scaledHeight = 100 * scaleSize
        let size         = CGSize(width: scaledWidth, height: scaledHeight)
        
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        
    }
}
