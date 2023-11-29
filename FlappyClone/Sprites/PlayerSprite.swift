import AVFoundation
import SpriteKit

class PlayerSprite: SKSpriteNode {
    
    // Actions
    private var upTurnOnFlap       = SKAction()
    private var upTurnOnCollide    = SKAction()
    private var downTurnAfterFlap  = SKAction()
    var downTurnIfNotCanceled      = SKAction()
    var toggleRecentlyScored       = SKAction()
    private var debounceFlap       = SKAction()
    
    // Player State
    var downTurnCanceled = Bool()
    var rejectFlap       = Bool()
    var recentlyScored   = Bool()
    
    // Sound
    private var flapSoundEffect = AVAudioPlayer()
    
    init() {
        let texture = SKTexture(imageNamed: "Birb")
        let size = CGSize(width: 60, height: 70)
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    // Bootstrap
    private func setupActions() {
        // SKActions
        self.upTurnOnFlap      = SKAction.rotate(toAngle: 0, duration: 0.7)
        self.upTurnOnCollide   = SKAction.rotate(toAngle: 0, duration: 0.15)
        let downAngle = (-CGFloat.pi / 2) * 0.8
        let downTurn  = SKAction.rotate(toAngle: downAngle, duration: 0.57)
        self.downTurnIfNotCanceled = SKAction.run({
            () in
            if !self.downTurnCanceled && self.recentlyScored {
                self.run(downTurn)
            } else {
                self.downTurnCanceled = false
            }
        })
        
        let enableDebounceFlap = SKAction.run({
            () in
            self.rejectFlap = true
        })
        let resetDebounceFlap  = SKAction.run({
            () in
            if self.rejectFlap {
                self.rejectFlap = false
            }
        })
        self.debounceFlap = SKAction.sequence([
            enableDebounceFlap,
            SKAction.wait(forDuration: 0.25),
            resetDebounceFlap
        ])
        
        let enableRecentlyScored = SKAction.run({
            () in
            self.recentlyScored = true
            print("Recently scored on")
        })
        let resetRecentlyScored = SKAction.run({
            () in
            self.recentlyScored = false
            print("Recently scored off")
        })
        self.toggleRecentlyScored = SKAction.sequence([
            enableRecentlyScored,
            SKAction.wait(forDuration: 1.5),
            resetRecentlyScored
        ])
    }
    
    private func setupSprite() {
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
        
        setupActions()
        
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
    
    // Methods
    public func rotateToZero(collision: Bool = false) {
        self.physicsBody?.angularVelocity = 0
        run(collision ? upTurnOnCollide : upTurnOnFlap)
    }
    
    public func flap(deltaY: CGFloat = 70) {
        if rejectFlap {
            print("Flap debounced")
            return
        }
        
//        if recentlyScored {
//            downTurnCanceled = true
//        }
        // This breaks down turning
        
        // Audiovisual + haptic feedback
        rotateToZero(collision: false)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if !UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted) {
            flapSoundEffect.play()
        }
        
        // Flap physics
        let vecNormalize = CGVectorMake(0, 0)
        let vecFlap   = CGVectorMake(0, deltaY)
        physicsBody?.velocity = vecNormalize
        physicsBody?.applyImpulse(vecFlap)
        run(debounceFlap)
    }
    
    public func downTurn() {
        run(downTurnIfNotCanceled)
    }
}
