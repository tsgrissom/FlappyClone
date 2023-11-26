import SpriteKit

class GroundSprite: SKSpriteNode {
    
    var isCloud = false
    
    init(frameWidth: CGFloat, imageName: String = "Clouds") {
        let texture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: frameWidth, height: 100)
        super.init(texture: texture, color: .clear, size: size)
        
        if imageName=="Clouds" {
            isCloud = true
        }
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        zPosition = 3
        
        let pbHeightMultiplier = if isCloud {
            0.3
        } else {
            1.0
        }
        let pbSize   = CGSize(
            width: self.size.width,
            height: self.size.height * pbHeightMultiplier
        )
        
        physicsBody = SKPhysicsBody(rectangleOf: pbSize)
        physicsBody?.categoryBitMask    = PhysicsCategory.Boundary
        physicsBody?.collisionBitMask   = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.affectedByGravity  = false
        physicsBody?.isDynamic          = false
        physicsBody?.restitution = 0.4
    }
}
