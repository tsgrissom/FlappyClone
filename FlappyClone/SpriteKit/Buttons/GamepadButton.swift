import GameController
import SpriteKit

class GamepadButton: SKSpriteNode {
    
    private let defaults = UserDefaults.standard
    private let buttonName: String
    
    init(
        buttonName: String
    ) {
        self.buttonName = buttonName
        
        let texture = SKTexture(imageNamed: "GamepadXbox\(buttonName)")
        let size    = CGSize(width: 40, height: 40)
        
        // TODO Support PlayStation button layout
        
        super.init(texture: texture, color: .clear, size: size)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonName = "A"
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func determineGamepadLayout() -> String {
        let preferredGamepadFormat = defaults.string(forKey: DefaultsKey.PreferredGamepad) ?? "Dynamic"
        var layout = ""
        
        if preferredGamepadFormat == "Sony" || preferredGamepadFormat == "PlayStation" {
            layout = "Sony"
        } else if preferredGamepadFormat == "Xbox" || preferredGamepadFormat == "Standard" {
            layout = "Xbox"
        } else { // Assume Dynamic
            for controller in GCController.controllers() {
                if controller.isPlayStationFormat() {
                    layout = "Sony"
                    break
                }
            }
        }
        
        if layout.isEmpty {
            layout = "Xbox"
        }
        
        return layout
    }
    
    private func setupButton() {
        let layout    = determineGamepadLayout()
        let imageName = "Gamepad\(layout)\(buttonName)"
        let texture   = SKTexture(imageNamed: imageName)
        
        let displayMode = defaults.string(forKey: DefaultsKey.GamepadDisplayMode)
        
        self.run(SKAction.setTexture(texture))
        
        if displayMode == "Dynamic" || displayMode == "Never" {
            self.run(SKAction.hide())
        }
    }
    
    // MARK: Methods
    public func hide() {
        self.run(SKAction.hide())
    }
    
    public func show() {
        self.run(SKAction.unhide())
    }
}
