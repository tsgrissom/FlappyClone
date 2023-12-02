import SpriteKit

class RemainingHitsLabel: SKLabelNode {
    
    private let sceneSetting: GameSceneSetting
    private let maxHits: Int
    private var remainingHits = Int()
    
    init(
        for sceneSetting: GameSceneSetting = .Day
    ) {
        self.sceneSetting = sceneSetting
        self.maxHits = UserDefaults.standard.integer(forKey: DefaultsKey.NumberOfWallHitsAllowed)
        self.remainingHits = maxHits
        
        super.init()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sceneSetting = .Day
        self.maxHits = UserDefaults.standard.integer(forKey: DefaultsKey.NumberOfWallHitsAllowed)
        self.remainingHits = maxHits
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        updateTextForHits(self.remainingHits)
        fontColor = calculateFontColor(max: maxHits, remaining: remainingHits)
        fontName = "04b_19"
        fontSize = UIDevice.isPhone() ? 35.0 : 25.0
    }
    
    private func calculateFontColor(max: Int, remaining: Int) -> UIColor {
        let high = UIColor(named: "SuccessColor") ?? UIColor.systemGreen
        let med = UIColor.systemYellow
        let low = UIColor(named: "DangerColor") ?? UIColor.systemRed
        
        if max == 0 {
            return high
        }
        
        let divided = Double(remaining) / Double(max)
        
        return if divided > 0.70 {
            high
        } else if divided > 0.35 {
            med
        } else {
            low
        }
    }
    
    public func updateTextForHits(_ remainingHits: Int) {
        self.remainingHits = remainingHits
        fontColor = calculateFontColor(max: self.maxHits, remaining: remainingHits)
        text = "Lives: \(remainingHits)"
    }
}
