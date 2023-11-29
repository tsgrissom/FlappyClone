import SpriteKit

class PlayButton: SKSpriteNode {
    
    private let sceneSetting: GameSceneSetting
    private let scaleSize: Double
    private let textureNameBtnPlayDark  = "BtnPlay-Dark"
    private let textureNameBtnPlayLight = "BtnPlay-Light"
    
    private func getTextureNameNotPressed() -> String {
        sceneSetting.isDark() ? textureNameBtnPlayLight : textureNameBtnPlayDark
    }
    
    private func getTextureNamePressed() -> String {
        sceneSetting.isDark() ? textureNameBtnPlayDark : textureNameBtnPlayLight
    }
    
    var onPress = SKAction()
    
    init(
        for sceneSetting: GameSceneSetting = .Day,
        scaleSize: Double = 1.0
    ) {
        self.sceneSetting = sceneSetting
        self.scaleSize = scaleSize
        
        let imageName  = sceneSetting.isDark() ? textureNameBtnPlayLight : textureNameBtnPlayDark
        let texture    = SKTexture(imageNamed: imageName)
        let sideLength = 100 * scaleSize
        let size       = CGSize(width: sideLength, height: sideLength)
        
        super.init(texture: texture, color: .clear, size: size)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        self.scaleSize = 1.0
        
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        let textureNotPressed = SKTexture(imageNamed: getTextureNameNotPressed())
        let texturePressed = SKTexture(imageNamed: getTextureNamePressed())
        
        let switchTextureToPressed = SKAction.setTexture(texturePressed)
        let delay = SKAction.wait(forDuration: 0.75)
        let resetTexture = SKAction.setTexture(textureNotPressed)
        onPress = SKAction.sequence([
            switchTextureToPressed,
            delay,
            resetTexture
        ])
    }
    
    func pressed() {
        self.run(onPress)
    }
}
