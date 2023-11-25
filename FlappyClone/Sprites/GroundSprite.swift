import SpriteKit

class GroundSprite: SKSpriteNode {
    
    init(width: CGFloat, height: CGFloat) {
        let texture = SKTexture(imageNamed: "Clouds")
        let size = CGSize(width: width, height: height)
        super.init(texture: texture, color: .clear, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        zPosition = 3
        
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.categoryBitMask    = PhysicsCategory.Boundary
        physicsBody?.collisionBitMask   = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.affectedByGravity  = false
        physicsBody?.isDynamic          = false
    }
}
