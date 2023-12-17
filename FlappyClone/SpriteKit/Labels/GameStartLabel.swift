import GameController
import SpriteKit

class GameStartLabel: SKNode {
    
    // MARK: Variables
    public var defaultFontSize: CGFloat {
        UIDevice.isPhone() ? 45.0 : 35.0
    }
    private let sceneSetting: GameSceneSetting
    
    // MARK: Components
    public var gamepadHint = GamepadButton(buttonName: "A")
    public let label       = SKLabelNode()
    
    // MARK: Initializers
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        super.init()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        super.init(coder: aDecoder)
        setupNode()
    }
    
    // MARK: Setup Functions
    public func setupNode() {
        var isGamepadConnected = false
        for controller in GCController.controllers() {
            if controller.extendedGamepad != nil {
                isGamepadConnected = true
            }
        }
        
        renderNode(withGamepadHint: isGamepadConnected)
    }
    
    public func renderNode(withGamepadHint: Bool) {
        removeAllChildren()
        gamepadHint = GamepadButton(buttonName: "A")
        
        let contextualText = if withGamepadHint {
            "to start"
        } else {
            "Tap to start"
        }
        
        label.fontColor = sceneSetting.getFontColor()
        label.fontName  = "04b_19"
        label.fontSize  = self.defaultFontSize
        label.text      = contextualText
        
        addChild(label)
        
        if withGamepadHint {
            gamepadHint.show()
            gamepadHint.position = CGPoint(x: gamepadHint.position.x - 125, y: gamepadHint.position.y + 17)
            addChild(gamepadHint)
        }
    }
}
