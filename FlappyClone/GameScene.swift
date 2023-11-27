import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {

    // Sprites
    var player     = PlayerSprite()        // Physics category - Player
    var walls      = WallSprite()
    var scoreLabel = SKLabelNode()
    var restartButton = SKSpriteNode()
    
    // Sprite Actions
    var moveAndRemove     = SKAction()
    var flashLabelOnReset = SKAction()
    
    // Game State
    var gameStarted = Bool()
    var score       = Int()
    
    // Sound Effects
    var scoreSoundEffect: AVAudioPlayer?
    
    private func loadSoundEffects() {
        if let path = Bundle.main.path(forResource: "Score", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                scoreSoundEffect = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Could not make AVAudioPlayer<-\"Score.mp3\"")
            }
        } else {
            print("\"Score.mp3\" not found in bundle")
        }
    }
    
    private func setupActions() {
        let makeLabelRed = SKAction.run({
            () in
            self.scoreLabel.fontColor = UIColor.systemRed
        })
        let resetLabelColor = SKAction.run({
            () in
            self.scoreLabel.fontColor = UIColor.white
        })
        flashLabelOnReset = SKAction.sequence([
            makeLabelRed,
            SKAction.wait(forDuration: 1.0),
            resetLabelColor
        ])
    }
    
    // MARK: Game State Functions
    private func endGame(for debugMessage: String = "Player hit Wall") {
//        gameStarted = false
//        print("End: \(debugMessage)")
        setScore(to: 0)
        run(flashLabelOnReset)
    }
    
    private func restartScene() {
        gameStarted = false
        score = 0
        self.removeAllChildren()
        self.removeAllActions()
        createScene()
    }
    
    private func createScene() {
        self.backgroundColor = UIColor.cyan
        self.physicsWorld.contactDelegate = self
        
        loadSoundEffects()
        setupActions()
        
        // Static Sprites
        let background = SKSpriteNode(imageNamed: "BG-Day")
        let cloud  = GroundSprite(frameWidth: frame.width)
        let ground = GroundSprite(frameWidth: frame.width)
        
        background.scale(to: frame.size)
        background.zPosition = -1
        cloud.position  = calculateCloudPosition()
        cloud.zRotation = CGFloat(Double.pi)
        ground.position = calculateGroundPosition()

        // Dynamic Sprites
        scoreLabel = createScoreLabel()
        player = PlayerSprite()
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.physicsBody?.affectedByGravity = false
        
        addChild(background)
        addChild(scoreLabel)
        addChild(cloud)
        addChild(ground)
        addChild(player)
    }
    
    private func setScore(to points: Int) {
        self.score = points
        scoreLabel.text = "\(points)x"
    }
    
    private func addScore(_ points: Int = 1) {
        let newScore = self.score + points
        setScore(to: newScore)
        scoreSoundEffect?.play()
        player.run(player.toggleRecentlyScored)
    }
    
    private func createScoreLabel() -> SKLabelNode {
        let label = SKLabelNode()
        let frameWidthHalved  = frame.width / 2
        let frameHeightHalved = frame.height / 2
        
        let posX = if UIDevice.isPhone() {
            CGPoint(
                x: frame.midX - (frameWidthHalved  * 0.52),
                y: frame.midY + (frameHeightHalved * 0.7)
            )
        } else {
            CGPoint(
                x: frame.midX,
                y: frame.midY + (frameHeightHalved * 0.2)
            )
        }
        
        label.text = "0x"
        label.fontColor = UIColor.white
        label.fontSize = 65
        label.fontName = "04b_19"
        label.position = posX
        label.zPosition = 4
        
        return label
    }
    
    private func createRestartButton() {
        restartButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 200, height: 100))
        
        let frameWidthHalved  = frame.size.width  / 2
        let frameHeightHalved = frame.size.height / 2
        let posX = frame.midX - (frameWidthHalved  * 0.5)
        let posY = frame.midY + (frameHeightHalved * 0.58) // TODO iPad positioning
        
        restartButton.position = CGPoint(x: posX, y: posY)
        restartButton.zPosition = 6
        restartButton.texture = SKTexture(imageNamed: "BtnRestart")
        addChild(restartButton)
    }
    
    // MARK: Helper Functions
    private func calculateCloudPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = if UIDevice.isPhone() {
            0.95
        } else {
            0.35
        }
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateGroundPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = if UIDevice.isPhone() {
            0.95
        } else {
            0.35
        }
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    // Creates the walls
    private func createWalls() {
        walls = WallSprite()
        
        let frameHeightHalved = frame.height / 2
        let frameWidthHalved  = frame.width / 2
        
        let randomPositions = [0.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0]
        let random = randomPositions.randomElement() ?? 0.0
        
        let wallX    = frame.midX + (frameWidthHalved  * 0.9)
        let topWallY = frame.midY + (frameHeightHalved * 0.65)
        let btmWallY = frame.midY - (frameHeightHalved * 0.6) + random
        
        walls.spriteTop.position   = CGPoint(x: wallX, y: topWallY)
        walls.spriteBtm.position   = CGPoint(x: wallX, y: btmWallY)
        walls.spriteScore.position = CGPoint(x: wallX, y: 30)
        
     // let scoreNodeX = wallX + (btmWall.frame.width / 2) // If the score needs to be at the end of the pipe

        walls.run(moveAndRemove)
        
        self.addChild(walls)
    }
    
    // MARK: GameScene Functions
    
    // On first render of GameScene
    override func didMove(to view: SKView) {
        createScene()
    }
    
    // Handles each screen touch
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        if (!gameStarted) {
            player.physicsBody?.affectedByGravity = true
            gameStarted = true
            createRestartButton()
            
            let spawn = SKAction.run({
                () in
                self.createWalls()
            })
            let delay          = SKAction.wait(forDuration: 3.5)
            let spawnDelay     = SKAction.sequence([spawn, delay])
            let spawnDelayLoop = SKAction.repeatForever(spawnDelay)
            
            self.run(spawnDelayLoop)
            
            let distance    = CGFloat(self.frame.width + walls.frame.width)
            let movePipes   = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            player.flap()
        } else {
            player.flap()
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if (restartButton.contains(location)) {
                restartScene()
            }
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) { }
    
    // From SKPhysicsContactDelegate
    // Triggered on contact between two bodies
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let maskA = bodyA.categoryBitMask
        let maskB = bodyB.categoryBitMask
        
        if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Wall) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Wall)) {
            player.downTurnCanceled = true
            player.rotateToZero(collision: true)
            endGame(for: "Player hit Wall")
//            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        } else if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Boundary) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Boundary)) {
            player.downTurnCanceled = true
            player.rotateToZero(collision: true)
            endGame(for: "Player hit Ground")
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Score) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Score)) {
            addScore()
            
            if (maskA == PhysicsCategory.Score) {
                bodyA.node?.removeFromParent()
            } else if (maskB == PhysicsCategory.Score){
                bodyB.node?.removeFromParent()
            }
            
            let downTurnAfterScore = SKAction.sequence([
                SKAction.wait(forDuration: 0.8),
                player.downTurnIfNotCanceled
            ])
            
            player.run(downTurnAfterScore)
        }
    }
}
