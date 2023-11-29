import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {

    let defaults = UserDefaults.standard
    
    // Sprites
    var player         = PlayerSprite()        // Physics category - Player
    var walls          = WallSprite()
    var scoreLabel     = ScoreLabel()
    var gameStartLabel = GameStartLabel()
    var restartButton  = RestartButton()
    var quitButton     = QuitButton()
    
    // Sprite Actions
    var moveAndRemoveWalls = SKAction()
    
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
    
    // MARK: Game State Functions
    private func endGame(for debugMessage: String = "Player hit Wall") {
        print(debugMessage)
        setScore(to: 0)
        scoreLabel.flashDanger(waitDuration: 1.5)
    }
    
    private func startGame() {
        player.physicsBody?.affectedByGravity = true
        scoreLabel.updateTextForScore(0)
        gameStartLabel.run(SKAction.hide())
        
        self.addChild(restartButton)
        self.addChild(quitButton)
        
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
    
    private func restartScene() {
        gameStarted = false
        score = 0
        self.removeAllChildren()
        self.removeAllActions()
        createScene()
    }
    
    private func createScene(
        for sceneSetting: GameSceneSetting = GameSceneSetting.randomValue()
    ) {
        self.physicsWorld.contactDelegate = self
        
        loadSoundEffects()
        
        // Static Sprites
        let background = BackgroundSprite(for: sceneSetting, frameSize: frame.size)
        let cloud  = GroundSprite(frameWidth: frame.width, setting: sceneSetting)
        let ground = GroundSprite(frameWidth: frame.width, setting: sceneSetting)
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
        
        scoreLabel = ScoreLabel()
        scoreLabel.position  = calculateScoreLabelPosition()
        scoreLabel.zPosition = 4
        
        restartButton = RestartButton(for: sceneSetting)
        restartButton.position  = calculateRestartButtonPosition()
        restartButton.zPosition = 5
        
        quitButton = QuitButton(for: sceneSetting)
        quitButton.position  = calculateQuitButtonPosition()
        quitButton.zPosition = 5
        
        addChild(background)
        addChild(gameStartLabel)
        addChild(scoreLabel)
        addChild(cloud)
        addChild(ground)
        addChild(player)
    }
    
    // Game State Functions
    private func setScore(to points: Int) {
        self.score = points
        scoreLabel.updateTextForScore(points)
    }
    
    private func addScore(_ points: Int = 1) {
        let oldScore = self.score
        let newScore = oldScore + points
        let oldHighScore = defaults.integer(forKey: DefaultsKey.HighScore)
        
        setScore(to: newScore)
        player.run(player.toggleRecentlyScored)
        
        if newScore > oldHighScore {
            // TODO Play new high score effect
            UserDefaults.standard.setValue(newScore, forKey: DefaultsKey.HighScore)
        } else {
            if !UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted) {
                scoreSoundEffect?.play()
            }
        }
    }
    
    // Elements
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
        let yMultiplier = UIDevice.isPhone() ? 0.72 : 0.16 // TODO iPad positioning
        
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    
    private func calculateQuitButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.width  / 2
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.75 : 0.2
        
        return CGPoint(
            x: frame.midX - (frameWidthHalved  * 0.52),
            y: frame.midY + (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateRestartButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.width  / 2
        let frameHeightHalved = frame.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.75 : 0.2
        
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
        
        let wallX    = frame.midX + (frameWidthHalved  * 0.9)
        let topWallY = frame.midY + (frameHeightHalved * 0.65)
        let btmWallY = frame.midY - (frameHeightHalved * 0.6) + random
        
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
        
        if !gameStarted {
            startGame()
            player.flap()
        } else {
            player.flap()
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
