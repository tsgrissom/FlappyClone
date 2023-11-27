import SpriteKit

class BackgroundSprite: SKSpriteNode {
    
    let setting: GameSceneSetting
    private var frameSize = CGSize()
    
    init(
        for setting: GameSceneSetting = .Day,
        frameSize: CGSize
    ) {
        self.setting   = setting
        self.frameSize = frameSize
        let texture = SKTexture(imageNamed: setting.getBackgroundTextureImageName())
        super.init(texture: texture, color: .clear, size: frameSize)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.setting = .Day
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        scale(to: frameSize)
        zPosition = -1
    }
}
