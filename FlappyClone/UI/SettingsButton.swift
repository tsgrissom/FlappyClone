import SpriteKit

class SettingsButton: SKSpriteNode {
    
    init(
        for sceneSetting: GameSceneSetting = .Day,
        scaleSize: CGFloat = 1.0
    ) {
        let imageName    = sceneSetting.isDark() ? "BtnSettings-Light" : "BtnSettings-Dark"
        let texture      = SKTexture(imageNamed: imageName)
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
