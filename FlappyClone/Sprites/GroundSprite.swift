import SpriteKit

class GroundSprite: SKSpriteNode {
    
    private let setting: GameSceneSetting
    let imageName: String
    
    var isCloud: Bool {
        imageName.contains("Clouds")
    }
    
    init(frameWidth: CGFloat, setting: GameSceneSetting = .Day) {
        self.setting   = setting
        self.imageName = setting.getCloudTextureImageName()
        let  texture   = SKTexture(imageNamed: imageName)
        let  size      = CGSize(width: frameWidth, height: 100)
    
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.setting   = .Day
        self.imageName = setting.getBackgroundTextureImageName()
        
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        let pbHeightMultiplier = isCloud ? 0.3 : 1.0
        let pbSize = CGSize(
            width: self.size.width,
            height: self.size.height * pbHeightMultiplier
        )
        let restitution = isCloud ? 0.4 : 0.1
        
        physicsBody = SKPhysicsBody(rectangleOf: pbSize)
        physicsBody?.categoryBitMask    = PhysicsCategory.Boundary
        physicsBody?.collisionBitMask   = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.affectedByGravity  = false
        physicsBody?.isDynamic          = false
        physicsBody?.restitution        = restitution
    }
}
