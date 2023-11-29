import AVFoundation
import SpriteKit

class WallSprite: SKNode {
    
    var spriteTop   = SKSpriteNode(imageNamed: "PipeTop")
    var spriteBtm   = SKSpriteNode(imageNamed: "PipeBottom")
    var spriteScore = SKSpriteNode(imageNamed: "Coin")
    
    override init() {
        super.init()
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        spriteTop.setScale(0.6)
        spriteBtm.setScale(0.6)
        spriteScore.size = CGSize(width: 50, height: 50)
        
        spriteTop.physicsBody = SKPhysicsBody(rectangleOf: spriteTop.size)
        spriteTop.physicsBody?.categoryBitMask    = PhysicsCategory.Wall
        spriteTop.physicsBody?.collisionBitMask   = PhysicsCategory.Player
        spriteTop.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        spriteTop.physicsBody?.isDynamic = false
        spriteTop.physicsBody?.affectedByGravity = false
        
        spriteBtm.physicsBody = SKPhysicsBody(rectangleOf: spriteBtm.size)
        spriteBtm.physicsBody?.categoryBitMask    = PhysicsCategory.Wall
        spriteBtm.physicsBody?.collisionBitMask   = PhysicsCategory.Player
        spriteBtm.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        spriteBtm.physicsBody?.isDynamic = false
        spriteBtm.physicsBody?.affectedByGravity = false
        
        spriteScore.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 250))
        spriteScore.physicsBody?.categoryBitMask    = PhysicsCategory.Score
        spriteScore.physicsBody?.collisionBitMask   = 0
        spriteScore.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        spriteScore.physicsBody?.affectedByGravity = false
        spriteScore.physicsBody?.isDynamic = false
        
        addChild(spriteTop)
        addChild(spriteBtm)
        addChild(spriteScore)
    }
}
