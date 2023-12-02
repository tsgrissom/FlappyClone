import AVFoundation
import SpriteKit

class PlayerSprite: SKSpriteNode {
    
    private let defaults = UserDefaults.standard
    
    // Actions
    private var doUpTurnOnFlap           = SKAction()
    private var doUpTurnOnCollide        = SKAction()
    private var doDownTurnAfterFlap      = SKAction()
    public  var doDownTurnIfNotCancelled = SKAction()
    public  var doToggleRecentlyScored   = SKAction()
    private var doDebounceFlap           = SKAction()
    
    // Player State
    public var downTurnCanceled = Bool()
    public var rejectFlap       = Bool()
    public var recentlyScored   = Bool()
    
    // Sound
    private var flapSoundEffect = AVAudioPlayer()
    
    // MARK: Computed
    private var audioNotMuted: Bool {
        !defaults.bool(forKey: DefaultsKey.AudioMuted)
    }
    
    private var hapticsNotDisabled: Bool {
        !defaults.bool(forKey: DefaultsKey.HapticsDisabled)
    }
    
    // MARK: Initializers
    init() {
        let texture = SKTexture(imageNamed: "Birb")
        let size    = CGSize(width: 60, height: 70)
        
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    // MARK: Setup
    private func setupActions() {
        // SKActions
        doUpTurnOnFlap    = SKAction.rotate(toAngle: 0, duration: 0.7)
        doUpTurnOnCollide = SKAction.rotate(toAngle: 0, duration: 0.15)
        
        let downAngle  = (-CGFloat.pi / 2) * 0.8
        let doDownTurn = SKAction.rotate(toAngle: downAngle, duration: 0.57)
        doDownTurnIfNotCancelled = SKAction.run({
            () in
            if !self.downTurnCanceled && self.recentlyScored {
                self.run(doDownTurn)
            } else {
                self.downTurnCanceled = false
            }
        })
        
        doDebounceFlap = SKAction.sequence([
            SKAction.run({
                () in
                self.rejectFlap = true
            }),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({
                () in
                if self.rejectFlap {
                    self.rejectFlap = false
                }
            })
        ])
        
        doToggleRecentlyScored = SKAction.sequence([
            SKAction.run({
                () in
                self.recentlyScored = true
            }),
            SKAction.wait(forDuration: 1.5),
            SKAction.run({
                () in
                self.recentlyScored = false
            })
        ])
    }
    
    private func setupAudio() {
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
    
    private func setupPhysicsBody() {
        let bodyRadius = CGFloat(self.frame.height / 3)
        physicsBody = SKPhysicsBody(circleOfRadius: bodyRadius)
        
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.collisionBitMask = PhysicsCategory.Boundary | PhysicsCategory.Wall
        physicsBody?.contactTestBitMask = PhysicsCategory.Boundary | PhysicsCategory.Wall | PhysicsCategory.Score
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.restitution = 0.3
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    private func setupSprite() {
        setScale(1.25)
        
        setupActions()
        setupAudio()
        setupPhysicsBody()
    }
    
    // MARK: Methods
    public func rotateToZero(collision: Bool = false) {
        self.physicsBody?.angularVelocity = 0
        run(collision ? doUpTurnOnCollide : doUpTurnOnFlap)
    }
    
    public func flap(deltaY: CGFloat = 70) {
        if rejectFlap {
            print("Flap debounced")
            return
        }
        
        // Audiovisual + haptic feedback
        rotateToZero(collision: false)
        
        if hapticsNotDisabled {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        if audioNotMuted {
            flapSoundEffect.play()
        }
        
        // Flap physics
        physicsBody?.velocity = CGVectorMake(0, 0)
        physicsBody?.applyImpulse(CGVectorMake(0, deltaY))
        run(doDebounceFlap)
    }
    
    public func downTurn() {
        run(doDownTurnIfNotCancelled)
    }
}
