import SpriteKit

class HighScoreLabel: SKLabelNode {
    
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
        let score = UserDefaults.standard.integer(forKey: DefaultsKey.HighScore)
        fontColor = sceneSetting.getFontColor()
        fontName = "04b_19"
        fontSize = UIDevice.isPhone() ? 35.0 : 25.0
        text = "High Streak: \(score)"
    }
}
