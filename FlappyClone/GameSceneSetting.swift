import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    case Day, Night
    
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
