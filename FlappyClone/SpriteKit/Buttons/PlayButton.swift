import SpriteKit

class PlayButton: SKSpriteNode {
    
    // MARK: Variables
    private let textureNameBtnPlayDark  = "BtnPlay-Dark"
    private let textureNameBtnPlayLight = "BtnPlay-Light"
    
    private let sceneSetting: GameSceneSetting
    
    public var onPress = SKAction()
    
    // MARK: Helper Functions
    private func getTextureNameNotPressed() -> String {
        sceneSetting.isDark() ? textureNameBtnPlayLight : textureNameBtnPlayDark
    }
    
    private func getTextureNamePressed() -> String {
        sceneSetting.isDark() ? textureNameBtnPlayDark : textureNameBtnPlayLight
    }
    
    // MARK: Initializers
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        
        let imageName  = sceneSetting.isDark() ? textureNameBtnPlayLight : textureNameBtnPlayDark
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
        let textureNotPressed = SKTexture(imageNamed: getTextureNameNotPressed())
        let texturePressed    = SKTexture(imageNamed: getTextureNamePressed())
        
        let setTexture = SKAction.setTexture(texturePressed)
        let delay = SKAction.wait(forDuration: 0.30)
        let resetTexture = SKAction.setTexture(textureNotPressed)
        onPress = SKAction.sequence([
            setTexture,
            delay,
            resetTexture
        ])
    }
    
    // MARK: Methods
    func press() {
        self.run(onPress)
    }
}
