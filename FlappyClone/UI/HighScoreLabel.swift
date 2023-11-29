import SpriteKit

class HighScoreLabel: SKLabelNode {
    
    override init() {
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        let score = UserDefaults.standard.integer(forKey: DefaultsKey.HighScore)
        text = "High score: \(score)"
        fontColor = .white
        fontName = "04b_19"
        fontSize = 45
    }
}
