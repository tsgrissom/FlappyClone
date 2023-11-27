import SpriteKit

class ScoreLabel: SKLabelNode {
    
    var flashOnDanger = SKAction()
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        // Initialize label
        text = "0x"
        fontColor = UIColor.white
        fontSize = 65
        fontName = "04b_19"
        
        // Actions
        let makeLabelRed = SKAction.run({
            () in
            self.fontColor = UIColor.systemRed
        })
        let resetLabelColor = SKAction.run({
            () in
            self.fontColor = UIColor.white
        })
        flashOnDanger = SKAction.sequence([
            makeLabelRed,
            SKAction.wait(forDuration: 1.0),
            resetLabelColor
        ])
    }
    
    func runFlashDanger() {
        self.run(flashOnDanger)
    }
    
    func updateTextForScore(_ new: Int) {
        text = "\(new)x"
    }
}
