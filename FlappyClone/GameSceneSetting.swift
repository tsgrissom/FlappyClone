import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    case Day, Night
    
    public func isLight() -> Bool {
        return switch (self) {
        case .Day:
            true
        case .Night:
            false
        }
    }
    
    public func isDark() -> Bool {
        return !isLight()
    }
    
    public func getBackgroundTextureImageName() -> String {
        return switch (self) {
        case .Day:
            "BG-Day"
        case .Night:
            "BG-Night"
        }
    }
    
    public func getCloudTextureImageName() -> String {
        return switch (self) {
        case .Day:
            "Clouds-Day"
        case .Night:
            "Clouds-Night"
        }
    }
}
