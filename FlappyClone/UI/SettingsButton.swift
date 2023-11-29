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
        text      = "Settings"
        fontColor = sceneSetting.isDark() ? UIColor.white : UIColor(named: "DarkColor")
        fontSize  = UIDevice.isPhone() ? 45.0 : 30.0
        fontName  = "04b_19"
    }
}
