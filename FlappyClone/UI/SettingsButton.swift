import SpriteKit

class SettingsButton: SKSpriteNode {
    
    private let imageNameSettingsDark  = "BtnSettings-Dark"
    private let imageNameSettingsGray  = "BtnSettings-Gray"
    private let imageNameSettingsLight = "BtnSettings-Light"
    
    private let sceneSetting: GameSceneSetting
    
    init(
        for sceneSetting: GameSceneSetting = .Day,
        scaleSize: CGFloat = 1.0
    ) {
        self.sceneSetting = sceneSetting
        
        let imageName  = sceneSetting.isDark() ? imageNameSettingsLight : imageNameSettingsDark
        let texture    = SKTexture(imageNamed: imageName)
        let sideLength = 200 * scaleSize
        let size       = CGSize(width: sideLength, height: sideLength)
        
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        
    }
}
