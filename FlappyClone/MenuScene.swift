import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    let defaults = UserDefaults.standard
    
    var playButton        = PlayButton()
    var settingsButton    = SettingsButton()
    var audioToggleButton = AudioMuteToggleButton()
    var gameScene         = SKScene()
    
    private func calculatePlayButtonPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * 0.25)
        )
    }
    
    private func calculateSettingsButtonPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        return CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * 0.01)
        )
    }
    
    private func calculateHighScoreLabelPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        return CGPoint(
            x: frame.midX,
            y: frame.midY - (frameHeightHalved * 0.2)
        )
    }
    
    private func calculateAudioToggleButtonPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        return CGPoint(
            x: frame.midX,
            y: frame.midY - (frameHeightHalved * 0.3)
        )
    }
    
    private func createScene() {
        let randomSetting = GameSceneSetting.randomValue()
        let background = BackgroundSprite(for: randomSetting, frameSize: frame.size)
        
        audioToggleButton = AudioMuteToggleButton()
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        audioToggleButton.zPosition = 2
        
        playButton = PlayButton()
        playButton.position = calculatePlayButtonPosition()
        playButton.zPosition = 2
        
        settingsButton = SettingsButton(for: randomSetting)
        settingsButton.position = calculateSettingsButtonPosition()
        settingsButton.zPosition = 2
        
        let highScoreLabel = HighScoreLabel(for: randomSetting)
        highScoreLabel.position = calculateHighScoreLabelPosition()
        highScoreLabel.zPosition = 2
        
        addChild(audioToggleButton)
        addChild(background)
        addChild(playButton)
        addChild(settingsButton)
        addChild(highScoreLabel)
    }
    
    private func setupNextScene() {
        if let nextScene = SKScene(fileNamed: "GameScene") {
            gameScene = nextScene
            gameScene.scaleMode = .aspectFill
        } else {
            print("Could not set up next scene GameScene")
        }
    }
    
    override func didMove(to view: SKView) {
        createScene()
        setupNextScene()
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if playButton.contains(location) {
                self.view?.presentScene(gameScene)
            } else if settingsButton.contains(location) {
                print("Settings button pressed")
                // TODO Some settings
                // TODO Toggle sound effects
                // TODO Credits
                // TODO Better visuals
            } else if audioToggleButton.contains(location) {
                audioToggleButton.toggle()
            }
        }
    }
}
