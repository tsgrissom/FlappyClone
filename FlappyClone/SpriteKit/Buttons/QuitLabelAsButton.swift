import SpriteKit

class QuitLabelAsButton: SKLabelNode {
    
    private let sceneSetting: GameSceneSetting
    
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
    
    private func setupLabel() {
        fontColor = sceneSetting.getFontColor()
        fontName  = "04b_19"
        fontSize  = UIDevice.isPhone() ? 35.0 : 25.0
        text      = "Quit"
    }
}
