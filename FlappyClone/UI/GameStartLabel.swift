import SpriteKit

class GameStartLabel: SKLabelNode {
    
    override init() {
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        text = "Tap to start"
        fontColor = .white
        fontSize = 45
        fontName = "04b_19"
    }
}
