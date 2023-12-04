import SpriteKit

class GameStartLabel: SKLabelNode {
    
    // MARK: Variables
    private let sceneSetting: GameSceneSetting
    
    // MARK: Initializers
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    // MARK: Setup Functions
    private func setupLabel() {
        fontColor = sceneSetting.getFontColor()
        fontName  = "04b_19"
        fontSize  = UIDevice.isPhone() ? 45.0 : 35.0
        text      = "Tap to start"
    }
}
