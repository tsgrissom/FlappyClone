import SpriteKit

class AudioMuteToggleButton: SKSpriteNode {
    
    private let unmutedTextureImageName = "BtnAudio"
    private let mutedTextureImageName   = "BtnAudio-Muted"
    
    var toggleMuted = SKAction()
    
    var isMuted = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    
    init(
        scaleSize: CGFloat = 1.0
    ) {
        let imageName    = isMuted ? mutedTextureImageName : unmutedTextureImageName
        let texture      = SKTexture(imageNamed: imageName)
        let scaledWidth  = 100 * scaleSize
        let scaledHeight = 100 * scaleSize
        let size         = CGSize(width: scaledWidth, height: scaledHeight)
        
        super.init(texture: texture, color: .clear, size: size)
        setupActions()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActions()
        setupButton()
    }
    
    private func setupActions() {
        toggleMuted = SKAction.run({
            () in
            if self.isMuted {
                self.isMuted = false
                UserDefaults.standard.setValue(false, forKey: DefaultsKey.AudioMuted)
                self.texture = SKTexture(imageNamed: self.unmutedTextureImageName)
            } else {
                self.isMuted = true
                UserDefaults.standard.setValue(true, forKey: DefaultsKey.AudioMuted)
                self.texture = SKTexture(imageNamed: self.mutedTextureImageName)
            }
        })
    }
    
    private func setupButton() {
        
    }
    
    func toggle() {
        self.run(toggleMuted)
    }
}
