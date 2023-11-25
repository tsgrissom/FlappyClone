import AVFoundation
import SpriteKit

class PlayerSprite: SKSpriteNode {
    
    private var upTurnOnFlap = SKAction()
    private var downTurnAfterFlap = SKAction()
    private var onFlap = SKAction()
    
    private var flapSoundEffect = AVAudioPlayer()
    
    init() {
        let texture = SKTexture(imageNamed: "Birb")
        let size = CGSize(width: 60, height: 70)
        super.init(texture: texture, color: .clear, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        zPosition = 2
        setScale(1.25)
        
        // Physics body
        let bodyRadius = CGFloat(self.frame.height / 3)
        physicsBody = SKPhysicsBody(circleOfRadius: bodyRadius)
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.collisionBitMask = PhysicsCategory.Boundary | PhysicsCategory.Wall
        physicsBody?.contactTestBitMask = PhysicsCategory.Boundary | PhysicsCategory.Wall | PhysicsCategory.Score
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.restitution = 0.3
        
        // SKActions
        upTurnOnFlap = SKAction.rotate(toAngle: 0, duration: 0.65)
        downTurnAfterFlap = SKAction.sequence([
            SKAction.wait(forDuration: 0.65),
            SKAction.rotate(toAngle: -CGFloat.pi/2, duration: 0.57)
        ])
        onFlap = SKAction.sequence([
            upTurnOnFlap,
            downTurnAfterFlap
        ])
        
        // Audio
        if let path = Bundle.main.path(forResource: "sfx_wing", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                flapSoundEffect = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Failed to create AVAudioPlayer for \"sfx_flap.mp3\".")
            }
        } else {
            print("\"sfx_flap.mp3\" not found in bundle.")
        }
    }
    
    public func flap(deltaY: CGFloat = 70) {
        // Audiovisual + haptic feedback
        run(onFlap)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        flapSoundEffect.play()
        
        // Flap physics
        physicsBody?.velocity = CGVectorMake(0, 0)
        physicsBody?.applyImpulse(CGVectorMake(0, deltaY))
    }
}
