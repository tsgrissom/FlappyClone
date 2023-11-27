import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var playButton     = PlayButton()
    var settingsButton = SettingsButton()
    
    private func positionPlayButton() {
        let frameHeightHalved = frame.size.height / 2
        let pos = CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * 0.1)
        )
        playButton.position = pos
        playButton.zPosition = 2
    }
    
    private func positionSettingsButton() {
        let frameHeightHalved = frame.size.height / 2
        let pos = CGPoint(
            x: frame.midX,
            y: frame.midY + (frameHeightHalved * 0.4)
        )
        settingsButton.position = pos
        settingsButton.zPosition = 2
    }
    
    private func createScene() {
        let background = BackgroundSprite(for: GameSceneSetting.randomValue(), frameSize: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        playButton = PlayButton()
        positionPlayButton()
        
        settingsButton = SettingsButton()
        positionSettingsButton()
        
        self.addChild(background)
        self.addChild(playButton)
        self.addChild(settingsButton)
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO
    }
}
