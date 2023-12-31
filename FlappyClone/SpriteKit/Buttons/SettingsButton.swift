import SpriteKit

class SettingsButton: SKSpriteNode {
    
    // MARK: Variables
    private let imageNameSettingsDark  = "BtnSettings-Dark"
    private let imageNameSettingsGray  = "BtnSettings-Gray"
    private let imageNameSettingsLight = "BtnSettings-Light"
    
    private let sceneSetting: GameSceneSetting
    
    private var onPress = SKAction()
    
    // MARK: Initializers
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        
        let imageName  = sceneSetting.isDark() ? imageNameSettingsLight : imageNameSettingsDark
        let texture    = SKTexture(imageNamed: imageName)
        let size       = CGSize(width: 100, height: 100)
        
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    // MARK: Setup Functions
    private func setupSprite() {
        let texturePressed = SKTexture(imageNamed: sceneSetting.isDark() ? imageNameSettingsGray  : imageNameSettingsLight)
        let textureNotPressed   = SKTexture(imageNamed: sceneSetting.isDark() ? imageNameSettingsLight : imageNameSettingsDark)
        let setTexture   = SKAction.setTexture(texturePressed)
        let delay        = SKAction.wait(forDuration: 0.30)
        let resetTexture = SKAction.setTexture(textureNotPressed)
        
        onPress = SKAction.sequence([
            setTexture,
            delay,
            resetTexture
        ])
    }
    
    // MARK: Methods
    public func press() {
        self.run(onPress)
    }
}
