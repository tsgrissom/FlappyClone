import SpriteKit

class ScoreLabel: SKLabelNode {
    
    let defaultFontColor: UIColor = UIColor(named: "DefaultScoreColor") ?? UIColor.yellow
    let dangerFontColor:  UIColor = UIColor(named: "DangerScoreColor")  ?? UIColor.systemRed
    
    override init() {
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        // Initialize label
        text = ""
        fontColor = defaultFontColor
        fontSize = 65
        fontName = "04b_19"
    }
    
    func flashDanger(waitDuration: Double = 1.0) {
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
    
    func updateTextForScore(_ new: Int) {
        text = "\(new)x"
    }
    
    func resetText() {
        text = ""
    }
}
