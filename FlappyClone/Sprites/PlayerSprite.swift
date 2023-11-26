import AVFoundation
import SpriteKit

class PlayerSprite: SKSpriteNode {
    
    private var upTurnOnFlap      = SKAction()
    private var upTurnOnCollide   = SKAction()
    private var downTurnAfterFlap = SKAction()
    var downTurnIfNotCanceled     = SKAction()
    
    var downTurnCanceled = Bool()
    
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
        physicsBody?.usesPreciseCollisionDetection = true
        
        // SKActions
        upTurnOnFlap      = SKAction.rotate(toAngle: 0, duration: 0.7)
        upTurnOnCollide   = SKAction.rotate(toAngle: 0, duration: 0.15)
        let downTurn = SKAction.rotate(toAngle: -CGFloat.pi/2, duration: 0.57)
        downTurnIfNotCanceled = SKAction.run({
            () in
            if !self.downTurnCanceled {
                self.run(downTurn)
            } else {
                self.downTurnCanceled = false
            }
        })
        
        // Audio
        if let path = Bundle.main.path(forResource: "Flap", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                flapSoundEffect = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Could not make AVAudioPlayer<-\"Flap.mp3\".")
            }
        } else {
            print("\"Flap.mp3\" not found in bundle.")
        }
    }
    
    public func rotateToZero(collision: Bool = false) {
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.angularDamping = 0
        run(collision ? upTurnOnCollide : upTurnOnFlap)
    }
    
    public func flap(deltaY: CGFloat = 70) {
        // Audiovisual + haptic feedback
        rotateToZero(collision: false)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        flapSoundEffect.play()
        
        // Flap physics
        let vecNormalize = CGVectorMake(0, 0)
        let vecFlap   = CGVectorMake(0, deltaY)
        physicsBody?.velocity = vecNormalize
        physicsBody?.applyImpulse(vecFlap)
    }
    
    public func downTurn() {
        run(downTurnIfNotCanceled)
    }
}
