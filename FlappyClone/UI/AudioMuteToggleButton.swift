import SpriteKit

class AudioMuteToggleButton: SKSpriteNode {
    
    private let textureImageNameDark       = "BtnAudio-Dark"
    private let textureImageNameDarkMuted  = "BtnAudio-DarkMuted"
    private let textureImageNameLight      = "BtnAudio-Light"
    private let textureImageNameLightMuted = "BtnAudio-LightMuted"
    
    var toggleMuted = SKAction()
    
    private let sceneSetting: GameSceneSetting
    var isMuted = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    
    init(
        for sceneSetting: GameSceneSetting = .Day,
        scaleSize: CGFloat = 1.0
    ) {
        self.sceneSetting = sceneSetting
        
        let imageName = if sceneSetting.isDark() { // dark setting
            isMuted ? textureImageNameLightMuted : textureImageNameLight
        } else { // light setting
            isMuted ? textureImageNameDarkMuted : textureImageNameDark
        }
        
        let texture      = SKTexture(imageNamed: imageName)
        let scaledWidth  = 100 * scaleSize
        let scaledHeight = 100 * scaleSize
        let size         = CGSize(width: scaledWidth, height: scaledHeight)
        
        super.init(texture: texture, color: .clear, size: size)
        setupActions()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupActions()
        setupButton()
    }
    
    private func getMutedTextureName() -> String {
        sceneSetting.isDark() ? textureImageNameLightMuted : textureImageNameDarkMuted
    }
    
    private func getUnmutedTextureName() -> String {
        sceneSetting.isDark() ? textureImageNameLight : textureImageNameDark
    }
    
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
    
    func toggle() {
        self.run(toggleMuted)
    }
}
