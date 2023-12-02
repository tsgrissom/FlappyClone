import SpriteKit

class BackgroundSprite: SKSpriteNode {
    
    private let setting: GameSceneSetting
    private var frameSize = CGSize()
    
    init(
        for setting: GameSceneSetting = .Day,
        frameSize: CGSize
    ) {
        self.setting   = setting
        self.frameSize = frameSize
        
        let texture = setting.getBackgroundTexture()
        
        super.init(texture: texture, color: .clear, size: frameSize)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.setting = .Day
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    private func setupSprite() {
        scale(to: frameSize)
        zPosition = -1
    }
}
