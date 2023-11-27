import SpriteKit

class ScoreLabel: SKLabelNode {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        // Initialize label
        text = ""
        fontColor = UIColor.white
        fontSize = 65
        fontName = "04b_19"
    }
    
    func flashDanger(waitDuration: Double = 1.0) {
        let makeLabelRed = SKAction.run({
            () in
            self.fontColor = UIColor.systemRed
        })
        let resetLabelColor = SKAction.run({
            () in
            self.fontColor = UIColor.white
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
