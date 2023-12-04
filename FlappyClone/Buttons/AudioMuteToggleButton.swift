import SpriteKit

class AudioMuteToggleButton: SKSpriteNode {
    
    // MARK: Variables
    private let textureImageNameDark       = "BtnAudio-Dark"
    private let textureImageNameDarkMuted  = "BtnAudio-DarkMuted"
    private let textureImageNameLight      = "BtnAudio-Light"
    private let textureImageNameLightMuted = "BtnAudio-LightMuted"
    
    private let sceneSetting: GameSceneSetting
    
    public var toggleMuted = SKAction()
    public var isMuted = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    
    // MARK: Helper Functions
    private func getMutedTextureName() -> String {
        sceneSetting.isDark() ? textureImageNameLightMuted : textureImageNameDarkMuted
    }
    
    private func getUnmutedTextureName() -> String {
        sceneSetting.isDark() ? textureImageNameLight : textureImageNameDark
    }
    
    // MARK: Initialization
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        
        let imageName = if sceneSetting.isDark() { // dark setting
            isMuted ? textureImageNameLightMuted : textureImageNameLight
        } else { // light setting
            isMuted ? textureImageNameDarkMuted : textureImageNameDark
        }
        let texture      = SKTexture(imageNamed: imageName)
        
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))
        setupActions()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupActions()
        setupButton()
    }
    
    // MARK: Setup Functions
    private func setupActions() {
        toggleMuted = SKAction.run({
            () in
            if self.isMuted {
                self.isMuted = false
                UserDefaults.standard.setValue(false, forKey: DefaultsKey.AudioMuted)
                self.texture = SKTexture(imageNamed: self.getUnmutedTextureName())
            } else {
                self.isMuted = true
                UserDefaults.standard.setValue(true, forKey: DefaultsKey.AudioMuted)
                self.texture = SKTexture(imageNamed: self.getMutedTextureName())
            }
        })
    }
    
    private func setupButton() {
        
    }
    
    // MARK: Methods
    func toggle() {
        self.run(toggleMuted)
    }
}
