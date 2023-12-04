import SpriteKit
import GameplayKit
import SwiftUI

class MenuScene: SKScene {
    
    // TODO Credits
    
    // MARK: Variables
    private let defaults = UserDefaults.standard
    private let sceneSetting = GameSceneSetting.randomValue()
    
    private var playButton        = PlayButton()
    private var settingsButton    = SettingsButton()
    private var audioToggleButton = AudioMuteToggleButton()
    private var gameScene         = SKScene()
    
    // MARK: UI Positioning Functions
    private func horizontallyCenteredPoint(y: CGFloat) -> CGPoint {
        CGPoint(x: frame.midX, y: y)
    }
    
    private func calculatePlayButtonPosition() -> CGPoint {
        let frameHeightHalved = frame.size.height / 2
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.25 : 0.15
        } else {
            0.15
        }
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
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.15 : 0.05
        } else {
            0.12
        }
        
        return CGPoint(
            x: frame.midX + (frameWidthHalved  * xMultiplier),
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    private func calculateAudioToggleButtonPosition() -> CGPoint {
        let frameWidthHalved  = frame.size.width  / 2
        let frameHeightHalved = frame.size.height / 2
        let xMultiplier = UIDevice.isPhone() ? 0.2  : 0.1
    
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.15 : 0.05
        } else {
            0.12
        }
        
        return CGPoint(
            x: frame.midX - (frameWidthHalved  * xMultiplier),
            y: frame.midY - (frameHeightHalved * yMultiplier)
        )
    }
    
    // MARK: Button Handlers
    private func onPressPlayButton() {
        if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        playButton.run(playButton.onPress) {
            self.view?.presentScene(self.gameScene)
        }
    }
    
    private func onPressSettingsButton() {
        settingsButton.press()
        if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        openSettingsView()
    }
    
    private func onPressAudioToggleButton() {
        if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        audioToggleButton.toggle()
    }
    
    // MARK: Scene Control Functions
    private func createScene() {
        let background = BackgroundSprite(for: sceneSetting, frameSize: frame.size)
        
        playButton = PlayButton(
            for: sceneSetting,
            scaleSize: UIDevice.isPhone() ? 2.0 : 1.0
        )
        playButton.position = calculatePlayButtonPosition()
        playButton.zPosition = 2
        
        let highScoreLabel = HighScoreLabel(for: sceneSetting)
        highScoreLabel.position = calculateHighScoreLabelPosition()
        highScoreLabel.zPosition = 2
        
        audioToggleButton = AudioMuteToggleButton(
            for: sceneSetting,
            scaleSize: UIDevice.isPhone() ? 1.0 : 0.5
        )
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        audioToggleButton.zPosition = 2
        
        settingsButton = SettingsButton(
            for: sceneSetting,
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
        let settingsViewController = UIHostingController(rootView: SettingsView())
        if let viewController = view?.window?.rootViewController {
            viewController.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: GameScene Functions
    override func didMove(to view: SKView) {
        createScene()
        setupNextScene()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func deviceDidRotate() {
        if UIDevice.current.orientation.isFlat && (!UIDevice.current.orientation.isPortrait || !UIDevice.current.orientation.isLandscape) {
            return
        }
        
        let isLandscape = UIDevice.current.orientation.isLandscape
        let isPortrait  = UIDevice.current.orientation.isPortrait
        
        let btnPlayScaledLength = if isPortrait {
            UIDevice.isPhone() ? 200 : 100
        } else {
            100
        }
        
        playButton.scale(to: CGSize(width: btnPlayScaledLength, height: btnPlayScaledLength))
        playButton.position = calculatePlayButtonPosition()
        
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        settingsButton.position = calculateSettingsButtonPosition()
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if playButton.contains(location) {
                onPressPlayButton()
            } else if settingsButton.contains(location) {
                onPressSettingsButton()
            } else if audioToggleButton.contains(location) {
                onPressAudioToggleButton()
            }
        }
    }
}
