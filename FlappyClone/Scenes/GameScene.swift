import SpriteKit
import GameplayKit
import AVFoundation

// MARK: Single-Use Buttons
private class QuitLabelAsButton: SKLabelNode {
    
    let sceneSetting: GameSceneSetting
    
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        fontColor = sceneSetting.isDark() ? UIColor.white : UIColor(named: "DarkColor")
        fontName  = "04b_19"
        fontSize  = 35.0
        text      = "Quit"
    }
}

private class RestartLabelAsButton: SKLabelNode {
    
    let sceneSetting: GameSceneSetting
    
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        fontColor = sceneSetting.isDark() ? UIColor.white : UIColor(named: "DarkColor")
        fontName  = "04b_19"
        fontSize  = 35.0
        text      = "Restart"
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    // Sprites
    private var player         = PlayerSprite()        // Physics category - Player
    private var walls          = WallSprite()
    private var scoreLabel     = ScoreLabel()
    private var livesLabel     = RemainingHitsLabel()
    private var gameStartLabel = GameStartLabel()
    private var restartButton  = RestartLabelAsButton()
    private var quitButton     = QuitLabelAsButton()
    
    // Sprite Actions
    private var moveAndRemoveWalls = SKAction()
    
    // Game State
    private var gameStarted       = Bool()
    private var dead              = Bool()
    private var score             = Int()
    private var remainingWallHits = Int()
    
    // Sound Effects
    private var scoreSoundEffect: AVAudioPlayer?
    private var splatSoundEffect: AVAudioPlayer?
    
    // MARK: Setup Functions
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
        
        if let path = Bundle.main.path(forResource: "Splat", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                splatSoundEffect = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Could not make AVAudioPlayer<-\"Splat.mp3\"")
            }
        } else {
            print("\"Score.mp3\" not found in bundle")
        }
    }
    
    // MARK: Game State Functions
    private func setScore(to points: Int) {
        self.score = points
        scoreLabel.updateTextForScore(points)
    }
    
    private func addScore(_ points: Int = 1) {
        let oldScore = self.score
        let newScore = oldScore + points
        let oldHighScore = defaults.integer(forKey: DefaultsKey.HighScore)
        
        setScore(to: newScore)
        player.run(player.doToggleRecentlyScored)
        
        if newScore > oldHighScore {
            // TODO Play new high score effect
            defaults.setValue(newScore, forKey: DefaultsKey.HighScore)
        } else {
            if !defaults.bool(forKey: DefaultsKey.AudioMuted) {
                scoreSoundEffect?.play()
            }
        }
    }
    
    private func die(from debugMessage: String = "Player left frame") {
        print(debugMessage)
        dead = true
        livesLabel.text = "Dead!"
        livesLabel.fontColor = UIColor(named: "DangerColor")
        livesLabel.fontSize = 38
        player.removeFromParent()
        
        if !defaults.bool(forKey: DefaultsKey.AudioMuted) {
            splatSoundEffect?.play()
        }
    }
    
    private func endGame(for debugMessage: String = "Player hit Wall") {
        print(debugMessage)
        setScore(to: 0)
        scoreLabel.flashDanger(waitDuration: 1.5)
    }
    
    private func startGame() {
        player.physicsBody?.affectedByGravity = true
        scoreLabel.updateTextForScore(0)
        gameStartLabel.run(SKAction.hide())
        
        addChild(restartButton)
        addChild(quitButton)
        if remainingWallHits > 0 && defaults.bool(forKey: DefaultsKey.DieOnHitWall) {
            addChild(livesLabel)
        }
        
        let spawn = SKAction.run({
            () in
            self.createWalls()
        })
        let delay          = SKAction.wait(forDuration: 3.5)
        let spawnDelay     = SKAction.sequence([spawn, delay])
        let spawnDelayLoop = SKAction.repeatForever(spawnDelay)
        
        let distance    = CGFloat(self.frame.width + walls.frame.width)
        let movePipes   = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.008 * distance))
        let removePipes = SKAction.removeFromParent()
        
        moveAndRemoveWalls = SKAction.sequence([movePipes, removePipes])
        
        self.run(spawnDelayLoop)
        gameStarted = true
    }
    
    private func quitGame() {
        if let menuScene = SKScene(fileNamed: "MenuScene") {
            menuScene.scaleMode = .aspectFill
            self.view?.presentScene(menuScene)
        }
    }
    
    // MARK: Scene Control Functions
    private func restartScene() {
        dead = false
        gameStarted = false
        score = 0
        remainingWallHits = 0
        self.removeAllChildren()
        self.removeAllActions()
        createScene()
    }
    
    private func createScene(
        for sceneSetting: GameSceneSetting = GameSceneSetting.getPreferredSceneSetting()
    ) {
        self.physicsWorld.contactDelegate = self
        
        loadSoundEffects()
        remainingWallHits = defaults.integer(forKey: DefaultsKey.NumberOfWallHitsAllowed)
        
        // Static Sprites
        let background = BackgroundSprite(for: sceneSetting, frameSize: frame.size)
        let cloud  = GroundSprite(for: sceneSetting)
        let ground = GroundSprite(for: sceneSetting)
        cloud.position   = calculateCloudPosition()
        cloud.zRotation  = CGFloat(Double.pi)
        cloud.zPosition  = 3
        ground.position  = calculateGroundPosition()
        ground.zPosition = 3
        
        gameStartLabel = GameStartLabel(for: sceneSetting)
        gameStartLabel.position = calculateGameStartLabelPosition()
        gameStartLabel.zPosition = 4
        
        // Dynamic Sprites
        player = PlayerSprite()
        player.position  = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = 2
        player.physicsBody?.affectedByGravity = false
        
        scoreLabel = ScoreLabel(for: sceneSetting)
        scoreLabel.position  = calculateScoreLabelPosition()
        scoreLabel.zPosition = 4
        
        livesLabel = RemainingHitsLabel(for: sceneSetting)
        livesLabel.position = calculateRemainingHitsLabelPosition()
        livesLabel.zPosition = 4
        
        restartButton = RestartLabelAsButton(for: sceneSetting)
        restartButton.position  = calculateRestartButtonPosition()
        restartButton.zPosition = 5
        
        quitButton = QuitLabelAsButton(for: sceneSetting)
        quitButton.position  = calculateQuitButtonPosition()
        quitButton.zPosition = 5
        
        addChild(background)
        addChild(gameStartLabel)
        addChild(scoreLabel)
        addChild(cloud)
        addChild(ground)
        addChild(player)
    }
    
    // MARK: Element Positioning Functions
    private func calculateCloudPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.95 : 0.35
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateGroundPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.95 : 0.35
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateGameStartLabelPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.3 : 0.15
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateScoreLabelPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.75 : 0.20 // TODO iPad positioning
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateRemainingHitsLabelPosition() -> CGPoint {
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.65 : 0.15
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateQuitButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.width  / 2
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.75 : 0.20
        
        return CGPoint(
            x: frame.midX - (frameWidthHalved  * 0.52),
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateRestartButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.width  / 2
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.75 : 0.20
        
        return CGPoint(
            x: frame.midX + (frameWidthHalved  * 0.52),
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    // Creates the walls
    private func createWalls() {
        walls = WallSprite()
        
        let frameHeightHalved = frame.height / 2
        let frameWidthHalved  = frame.width / 2
        
        let randomPositions = [0.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0]
        let random = randomPositions.randomElement() ?? 0.0
        
        let wallX    = frame.midX + (frameWidthHalved  * 0.90)
        let topWallY = frame.midY + (frameHeightHalved * 0.65)
        let btmWallY = frame.midY - (frameHeightHalved * 0.60) + random
        
        walls.spriteTop.position   = CGPoint(x: wallX, y: topWallY)
        walls.spriteBtm.position   = CGPoint(x: wallX, y: btmWallY)
        walls.spriteScore.position = CGPoint(x: wallX, y: 30)
        
        // let scoreNodeX = wallX + (btmWall.frame.width / 2)
        // If the score needs to be at the end of the pipe

        walls.run(moveAndRemoveWalls)
        
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
        for touch in touches {
            let location = touch.location(in: self)
            if restartButton.contains(location) {
                restartScene()
                return
            } else if quitButton.contains(location) {
                quitGame()
                return
            } else if scoreLabel.contains(location) {
                scoreLabel.flashHighScore(score: score)
                return
            }
        }
        
        if dead {
            return
        }
        
        if !gameStarted {
            startGame()
            player.flap()
        } else {
            player.flap()
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        if dead || !gameStarted {
            return
        }
        
        let px = player.position.x
        let py = player.position.y
        
        let isOutOfBounds = px < frame.minX || px > frame.maxX || py < frame.minY || py > frame.maxY
        let shouldDieOnOutOfBounds = defaults.bool(forKey: DefaultsKey.DieOnOutOfBounds)
        
        if isOutOfBounds && shouldDieOnOutOfBounds {
            die(from: "Player left frame")
        }
    }
    
    // From SKPhysicsContactDelegate
    // Triggered on contact between two bodies
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let maskA = bodyA.categoryBitMask
        let maskB = bodyB.categoryBitMask
        
        let shouldDieOnHitBoundary = defaults.bool(forKey: DefaultsKey.DieOnHitBoundary)
        let shouldDieOnHitWall     = defaults.bool(forKey: DefaultsKey.DieOnHitWall)
        
        if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Wall) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Wall)) {
            if remainingWallHits > 0 {
                remainingWallHits -= 1
                livesLabel.updateTextForHits(remainingWallHits)
                return
            }
            
            if shouldDieOnHitWall && remainingWallHits <= 0 {
                die(from: "Player hit Wall")
            }
            
            player.downTurnCanceled = true
            player.rotateToZero(collision: true)
            endGame(for: "Player hit Wall")
            
            if !defaults.bool(forKey: DefaultsKey.HapticsDisabled) {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
        } else if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Boundary) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Boundary)) {
            if shouldDieOnHitBoundary {
                die(from: "Player hit Boundary")
            }
            
            player.downTurnCanceled = true
            player.rotateToZero(collision: true)
            endGame(for: "Player hit Boundary")
            
            if !defaults.bool(forKey: DefaultsKey.HapticsDisabled) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        } else if ((maskA == PhysicsCategory.Player && maskB == PhysicsCategory.Score) || (maskB == PhysicsCategory.Player && maskA == PhysicsCategory.Score)) {
            addScore()
            
            if (maskA == PhysicsCategory.Score) {
                bodyA.node?.removeFromParent()
            } else if (maskB == PhysicsCategory.Score){
                bodyB.node?.removeFromParent()
            }
            
            let downTurnAfterScore = SKAction.sequence([
                SKAction.wait(forDuration: 0.8),
                player.doDownTurnIfNotCancelled
            ])
            
            player.run(downTurnAfterScore)
        }
    }
}
