import SpriteKit
import GameController
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
    
    private var playButtonGamepadHint = GamepadButton(buttonName: "A")
    
    private var gameScene         = SKScene()
    
    private var hapticsNotDisabled: Bool {
        !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled)
    }
    
    // MARK: Calculation Functions
    private func horizontallyCenteredPoint(y: CGFloat) -> CGPoint {
        CGPoint(x: frame.midX, y: y)
    }
    
    private func calculatePlayButtonPosition() -> CGPoint {
        let htHalved = frame.size.height / 2
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.25 : 0.15
        } else {
            0.15
        }
        let yPos = frame.midY + (htHalved * yMultiplier)
        
        return horizontallyCenteredPoint(y: yPos)
    }
    
    private func calculatePlayButtonScale() -> CGSize {
        let scaledLength = UIDevice.current.orientation.isPortrait && UIDevice.isPhone() ? 200 : 100
        return CGSize(width: scaledLength, height: scaledLength)
    }
    
    private func calculatePlayButtonGamepadHintPosition() -> CGPoint {
        let playX      = playButton.position.x
        let playY      = playButton.position.y
        let playWidth  = playButton.frame.width
        let playHeight = playButton.frame.height
        return CGPoint(
            x: playX + (playWidth/2),
            y: playY + (playHeight/2)
        )
    }
    
    private func calculateHighScoreLabelPosition() -> CGPoint {
        let htHalved = frame.size.height / 2
        let yPos = if UIDevice.isPhone() {
            frame.midY - (htHalved * 0.01)
        } else {
            frame.midY + (htHalved * 0.01)
        }
        return horizontallyCenteredPoint(y: yPos)
    }
    
    private func calculateSettingsButtonPosition() -> CGPoint {
        let wtHalved    = frame.size.width  / 2
        let htHalved    = frame.size.height / 2
        let xMultiplier = UIDevice.isPhone() ? 0.2  : 0.1
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.15 : 0.05
        } else {
            0.12
        }
         
        return CGPoint(
            x: frame.midX + (wtHalved * xMultiplier),
            y: frame.midY - (htHalved * yMultiplier)
        )
    }
    
    private func calculateAudioToggleButtonPosition() -> CGPoint {
        let wtHalved    = frame.size.width  / 2
        let htHalved    = frame.size.height / 2
        let xMultiplier = UIDevice.isPhone() ? 0.2  : 0.1
    
        let yMultiplier = if UIDevice.current.orientation.isPortrait {
            UIDevice.isPhone() ? 0.15 : 0.05
        } else {
            0.12
        }
        
        return CGPoint(
            x: frame.midX - (wtHalved * xMultiplier),
            y: frame.midY - (htHalved * yMultiplier)
        )
    }
    
    // MARK: Button Handler Functions
    private func onPressPlayButton() {
        if hapticsNotDisabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        playButton.run(playButton.onPress) {
            self.view?.presentScene(self.gameScene)
        }
    }
    
    private func onPressSettingsButton() {
        settingsButton.press()
        if hapticsNotDisabled {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        openSettingsView()
    }
    
    private func onPressAudioToggleButton() {
        if hapticsNotDisabled {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        audioToggleButton.toggle()
    }
    
    // MARK: Initializing Functions
    private func createScene() {
        let background = BackgroundSprite(for: sceneSetting, frameSize: frame.size)
        
        playButton = PlayButton(for: sceneSetting)
        playButton.position = calculatePlayButtonPosition()
        playButton.zPosition = 2
        playButton.scale(to: calculatePlayButtonScale())
        
        reinitializeGamepadHints()
        
        let highScoreLabel = HighScoreLabel(for: sceneSetting)
        highScoreLabel.position = calculateHighScoreLabelPosition()
        highScoreLabel.zPosition = 2
        
        audioToggleButton = AudioMuteToggleButton(for: sceneSetting)
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        audioToggleButton.zPosition = 2
        
        settingsButton = SettingsButton(for: sceneSetting)
        settingsButton.position = calculateSettingsButtonPosition()
        settingsButton.zPosition = 2
        
        addChild(background)
        addChild(highScoreLabel)
        addChild(audioToggleButton)
        addChild(playButton)
        addChild(playButtonGamepadHint)
        addChild(settingsButton)
        
        for controller in GCController.controllers() {
            if controller.extendedGamepad != nil {
                self.showGamepadHints()
            }
        }
    }
    
    private func setupNextScene() {
        if let nextScene = SKScene(fileNamed: "GameScene") {
            gameScene = nextScene
            gameScene.scaleMode = .aspectFill
        } else {
            print("Could not set up next scene GameScene")
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDidRotate),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidConnect),
            name: .GCControllerDidConnect,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidDisconnect),
            name: .GCControllerDidDisconnect,
            object: nil
        )
    }
     
    private func openSettingsView() {
        let settingsViewController = UIHostingController(rootView: SettingsView())
        if let viewController = view?.window?.rootViewController {
            viewController.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    private func showGamepadHints() {
        if defaults.string(forKey: DefaultsKey.GamepadDisplayMode) == "Never" {
            return
        }
        
        playButtonGamepadHint.show()
    }
    
    private func hideGamepadHints() {
        if defaults.string(forKey: DefaultsKey.GamepadDisplayMode) == "Always" {
            return
        }
        
        playButtonGamepadHint.hide()
    }
    
    private func reinitializeGamepadHints() {
        playButtonGamepadHint = GamepadButton(buttonName: "A")
        playButtonGamepadHint.position = calculatePlayButtonGamepadHintPosition()
        playButtonGamepadHint.zPosition = 3
    }
    
    // MARK: GameScene Functions
    override func didMove(to view: SKView) {
        createScene()
        setupNextScene()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameController = GCController.controllers().first {
            gameController.extendedGamepad?.buttonA.valueChangedHandler = { button, value, pressed in
                if pressed {
                    self.onPressPlayButton()
                }
            }
            gameController.extendedGamepad?.buttonB.valueChangedHandler = { button, value, pressed in
                if pressed {
                    self.onPressSettingsButton()
                }
            }
            gameController.extendedGamepad?.buttonX.valueChangedHandler = { button, value, pressed in
                if pressed {
                    self.onPressAudioToggleButton()
                }
            }
        }
    }
    
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
    
    // MARK: Objective-C Functions
    @objc func deviceDidRotate() {
        let isFlat      = UIDevice.current.orientation.isFlat
        let isLandscape = UIDevice.current.orientation.isLandscape
        let isPortrait  = UIDevice.current.orientation.isPortrait
        
        // Prevent rescale+reposition when device is laid flat without primary orientation change
        if isFlat && (!isLandscape || !isPortrait) {
            return
        }
        
        playButton.scale(to: calculatePlayButtonScale())
        playButton.position = calculatePlayButtonPosition()
        playButtonGamepadHint.position = calculatePlayButtonGamepadHintPosition()
        
        audioToggleButton.position = calculateAudioToggleButtonPosition()
        settingsButton.position = calculateSettingsButtonPosition()
    }
    
    @objc func controllerDidConnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            let vendorName = controller.getVendorName()
            print("Controller connected: \(vendorName)")
            controller.printLayout()
            
            self.reinitializeGamepadHints()
            self.showGamepadHints()
        }
    }
    
    @objc func controllerDidDisconnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            let vendorName = controller.getVendorName()
            print("Controller disconnected: \(vendorName)")
            
            self.hideGamepadHints()
        }
    }
}
