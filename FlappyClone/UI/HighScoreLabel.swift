import SpriteKit

class HighScoreLabel: SKLabelNode {
    
    let sceneSetting: GameSceneSetting
    
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
        let score = UserDefaults.standard.integer(forKey: DefaultsKey.HighScore)
        text = "High Streak: \(score)"
        fontColor = sceneSetting.isDark() ? .white : UIColor(named: "DarkColor")
        fontName = "04b_19"
        fontSize = UIDevice.isPhone() ? 35.0 : 25.0
    }
}
