import SpriteKit

class GameStartLabel: SKLabelNode {
    
    // MARK: Variables
    let sceneSetting: GameSceneSetting
    
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
        text = "Tap to start"
        fontColor = sceneSetting.isDark() ? .white : UIColor(named: "DarkColor")
        fontSize = 45
        fontName = "04b_19"
    }
}
