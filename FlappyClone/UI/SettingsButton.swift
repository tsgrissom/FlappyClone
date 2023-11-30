import SpriteKit

class SettingsButton: SKLabelNode {
    
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
        fontColor = sceneSetting.isDark() ? UIColor.white : UIColor(named: "DarkColor")
        fontName  = "04b_19"
        fontSize  = UIDevice.isPhone() ? 45.0 : 30.0
        text      = "Settings"
    }
}
