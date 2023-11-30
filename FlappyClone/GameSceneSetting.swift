import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    case Day, Day2, Night
    
    public func isLight() -> Bool {
        return switch (self) {
        case .Day:
            true
        case .Day2:
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
        case .Day2:
            "BG-Day2"
        case .Night:
            "BG-Night"
        }
    }
    
    public func getCloudTextureImageName() -> String {
        return switch (self) {
        case .Day, .Day2:
            "Clouds-Day"
        case .Night:
            "Clouds-Night"
        }
    }
}
