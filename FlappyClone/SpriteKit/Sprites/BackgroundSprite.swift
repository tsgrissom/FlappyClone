import SpriteKit

class BackgroundSprite: SKSpriteNode {
    
    // MARK: Variables
    private let sceneSetting: GameSceneSetting
    private var frameSize = CGSize()
    
    // MARK: Initializers
    init(
        for sceneSetting: GameSceneSetting = .Day,
        frameSize: CGSize
    ) {
        self.sceneSetting = sceneSetting
        self.frameSize    = frameSize
        
        let texture = sceneSetting.getBackgroundTexture()
        
        super.init(texture: texture, color: .clear, size: frameSize)
        setupSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupSprite()
    }
    
    // MARK: Setup
    private func setupSprite() {
        scale(to: frameSize)
        zPosition = -1
    }
}
