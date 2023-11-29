import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var playButton     = PlayButton()
    var settingsButton = SettingsButton()
    var gameScene      = SKScene()
    
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
    
    private func createScene() {
        let background = BackgroundSprite(for: GameSceneSetting.randomValue(), frameSize: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        playButton = PlayButton()
        playButton.position = calculatePlayButtonPosition()
        playButton.zPosition = 2
        
        settingsButton = SettingsButton()
        settingsButton.position = calculateSettingsButtonPosition()
        settingsButton.zPosition = 2
        
        addChild(background)
        addChild(playButton)
        addChild(settingsButton)
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
            }
            if settingsButton.contains(location) {
                print("Settings button pressed")
                // TODO Some settings
                // TODO Toggle sound effects
                // TODO Credits
                // TODO Better visuals
            }
        }
    }
}
