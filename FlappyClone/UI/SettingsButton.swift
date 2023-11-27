import SpriteKit

class SettingsButton: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "BtnSettings")
        let size    = CGSize(width: 200, height: 100)
        super.init(texture: texture, color: .clear, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
    }
}
