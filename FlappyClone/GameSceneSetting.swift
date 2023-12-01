import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    case Day, Day2, Day3, Night
    
    public func isLight() -> Bool {
        return switch (self) {
        case .Day, .Day2, .Day3:
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
        case .Day3:
            "BG-Day3"
        case .Night:
            "BG-Night"
        }
    }
    
    public func getCloudTextureImageName() -> String {
        return switch (self) {
        case .Day, .Day2, .Day3:
            "Clouds-Day"
        case .Night:
            "Clouds-Night"
        }
    }
}
