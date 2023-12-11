import SpriteKit

class GroundSprite: SKSpriteNode {
    
    // MARK: Variables
    private let imageName:    String
    private let sceneSetting: GameSceneSetting
    
    public var isCloud: Bool {
        imageName.contains("Clouds")
    }
    
    // MARK: Initializers
    init(for sceneSetting: GameSceneSetting = .Day) {
        self.sceneSetting = sceneSetting
        self.imageName    = sceneSetting.getCloudTextureImageName()
        
        let texture = SKTexture(imageNamed: imageName)
        let size    = CGSize(width: 1000, height: 100)
    
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting   = .Day
        self.imageName = sceneSetting.getBackgroundTextureImageName()
        
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    // MARK: Setup
    private func setupPhysicsBody() {
        let heightMultiplier = isCloud ? 0.15 : 1.0
        let size = CGSize(
            width: self.size.width,
            height: self.size.height * heightMultiplier
        )
        let restitution = isCloud ? 0.4 : 0.1
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask    = PhysicsCategory.Boundary
        physicsBody?.collisionBitMask   = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.affectedByGravity  = false
        physicsBody?.isDynamic          = false
        physicsBody?.restitution        = restitution
    }
    
    private func setupSprite() {
        setupPhysicsBody()
    }
}
