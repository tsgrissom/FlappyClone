import SpriteKit
import GameplayKit
import SwiftUI

private class SettingsLabelAsButton: SKLabelNode {
    
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
        fontSize  = UIDevice.isPhone() ? 45.0 : 30.0
        text      = "Settings"
    }
}

class MenuScene: SKScene {
    
    private let defaults = UserDefaults.standard
    
    private var playButton        = PlayButton()
    private var settingsButton    = SettingsButton()
    private var audioToggleButton = AudioMuteToggleButton()
    private var gameScene         = SKScene()
    
    private func horizontallyCenteredPoint(y: CGFloat) -> CGPoint {
        CGPoint(x: frame.midX, y: y)
    }
    
    private func calculatePlayButtonPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        let yMultiplier = UIDevice.isPhone() ? 0.25 : 0.15
        let yPos = frame.midY + (frameHeightHalved * yMultiplier)
        return horizontallyCenteredPoint(y: yPos)
    }
    
    private func calculateHighScoreLabelPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        let yPos = if UIDevice.isPhone() {
            frame.midY - (frameHeightHalved * 0.01)
        } else {
            frame.midY + (frameHeightHalved * 0.01)
        }
        return horizontallyCenteredPoint(y: yPos)
    }
    
    private func calculateSettingsButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.size.width  / 2
        let frameHeightHalved = frame.size.height / 2
        let xMultiplier = UIDevice.isPhone() ? 0.2  : 0.1
        let yMultiplier = UIDevice.isPhone() ? 0.15 : 0.05
        
        return CGPoint(
            x: frame.midX + (frameWidthHalved  * xMultiplier),
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateAudioToggleButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.size.width  / 2
        let frameHeightHalved = frame.size.height / 2
        let xMultiplier = UIDevice.isPhone() ? 0.2  : 0.1
        let yMultiplier = UIDevice.isPhone() ? 0.15 : 0.05
        
        return CGPoint(
            x: frame.midX - (frameWidthHalved  * xMultiplier),
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    private func createScene() {
        let randomSetting = GameSceneSetting.randomValue()
        let background = BackgroundSprite(for: randomSetting, frameSize: frame.size)
        
        playButton = PlayButton(
            for: randomSetting,
            scaleSize: UIDevice.isPhone() ? 2.0 : 1.0
        )
        playButton.position = calculatePlayButtonPosition()
        playButton.zPosition = 2
        
        let highScoreLabel = HighScoreLabel(for: randomSetting)
        highScoreLabel.position = calculateHighScoreLabelPosition()
        highScoreLabel.zPosition = 2
        
        audioToggleButton = AudioMuteToggleButton(
            for: randomSetting,
            scaleSize: UIDevice.isPhone() ? 1.0 : 0.5
        )
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        audioToggleButton.zPosition = 2
        
        settingsButton = SettingsButton(
            for: randomSetting,
            scaleSize: UIDevice.isPhone() ? 0.5 : 0.25
        )
        settingsButton.position = calculateSettingsButtonPosition()
        settingsButton.zPosition = 2
        
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
    
    private func openSettingsView() {
        let swiftUiController = UIHostingController(rootView: SettingsView())
        if let viewController = view?.window?.rootViewController {
            viewController.present(swiftUiController, animated: true, completion: nil)
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
                if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                
                self.view?.presentScene(gameScene)
            } else if settingsButton.contains(location) {
                if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                
                openSettingsView()
                // TODO Credits
            } else if audioToggleButton.contains(location) {
                if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                
                audioToggleButton.toggle()
            }
        }
    }
}
