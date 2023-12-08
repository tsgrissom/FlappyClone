import SpriteKit

class GamepadButton: SKSpriteNode {
    
    private let buttonName: String
    
    init(buttonName: String) {
        self.buttonName = buttonName
        
        let imageName = "Gamepad\(buttonName)"
        let texture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: 40, height: 40)
        
        // TODO Support PlayStation button layout
        
        super.init(texture: texture, color: .clear, size: size)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonName = "A"
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        self.run(SKAction.hide())
    }
    
    // MARK: Methods
    func hide() {
        self.run(SKAction.hide())
    }
    
    func show() {
        self.run(SKAction.unhide())
    }
}
