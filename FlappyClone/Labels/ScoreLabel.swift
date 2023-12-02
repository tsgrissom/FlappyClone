import SpriteKit

class ScoreLabel: SKLabelNode {
    
    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    private let defaultFontColor: UIColor = UIColor(named: "ScoreColor")   ?? UIColor.yellow
    private let dangerFontColor:  UIColor = UIColor(named: "DangerColor")  ?? UIColor.systemRed

    private let sceneSetting: GameSceneSetting
    private var isFlashingHighScore = false
    
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
        // Initialize label
        text = ""
        fontColor = defaultFontColor
        fontSize = 65
        fontName = "04b_19"
    }
    
    // MARK: Methods
    func flashDanger(waitDuration: Double = 1.0) {
        if isFlashingHighScore {
            return
        }
        
        let makeLabelRed = SKAction.run({
            () in
            self.fontColor = self.dangerFontColor
        })
        let resetLabelColor = SKAction.run({
            () in
            self.fontColor = self.defaultFontColor
        })
        let wait = SKAction.wait(forDuration: waitDuration)
        let action = SKAction.sequence([
            makeLabelRed,
            wait,
            resetLabelColor
        ])
        
        self.run(action)
    }
    
    func flashHighScore(
        score: Int,
        waitDuration: Double = 2.5
    ) {
        let highScore = defaults.integer(forKey: DefaultsKey.HighScore)
        let makeLabelHighScore = SKAction.run({
            () in
            self.isFlashingHighScore = true
            self.fontColor = self.sceneSetting.isDark() ? .white : UIColor(named: "DarkColor")
            self.fontSize = 45
            self.text = "High: \(highScore)"
        })
        let wait = SKAction.wait(forDuration: waitDuration)
        let restoreLabel = SKAction.run({
            () in
            self.isFlashingHighScore = false
            self.fontColor = self.defaultFontColor
            self.fontSize = 65
            self.updateTextForScore(score)
        })
        let action = SKAction.sequence([
            makeLabelHighScore,
            wait,
            restoreLabel
        ])
        
        self.run(action)
    }
    
    func updateTextForScore(
        _ new: Int
    ) {
        if isFlashingHighScore {
            return
        }
        
        text = "\(new)x"
    }
    
    func resetText() {
        text = ""
    }
}
