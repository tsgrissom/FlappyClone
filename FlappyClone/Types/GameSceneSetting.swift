import Foundation
import SpriteKit

enum GameSceneSetting: String, CaseIterable {
    
    case Day    = "Day"
    case Day2   = "Day2"
    case Day3   = "Day3"
    case Night  = "Night"
    case Night2 = "Night2"
    case Night3 = "Night3"
    case Night4 = "Night4"
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    public static func getRandomDarkScene() -> GameSceneSetting {
        GameSceneSetting.allCases
            .filter { it in it.isDark() }
            .randomElement() ?? .Night
    }
    
    public static func getRandomLightScene() -> GameSceneSetting {
        GameSceneSetting.allCases
            .filter { it in it.isLight() }
            .randomElement() ?? .Day
    }
    
    public static func getPreferredSceneSetting() -> GameSceneSetting {
        return switch (UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting)) {
        case "Random":
            randomValue()
        case "Day":
            getRandomLightScene()
        case "Night":
            getRandomDarkScene()
        default:
            GameSceneSetting.Day
        }
    }
    
    public func isLight() -> Bool {
        return if self.rawValue.contains("Day") {
            true
        } else {
            false
        }
    }
    
    public func isDark() -> Bool {
        return !isLight()
    }
    
    public func getBackgroundTextureImageName() -> String {
        let value = self.rawValue
        return "BG-\(value)"
    }
    
    public func getCloudTextureImageName() -> String {
        return switch (self) {
        case .Day, .Day2, .Day3:
            "Clouds-Day"
        case .Night, .Night2:
            "Clouds-Night"
        case .Night3, .Night4:
            "Clouds-Gray"
        }
    }
    
    public func getBackgroundTexture() -> SKTexture {
        return SKTexture(imageNamed: self.getBackgroundTextureImageName())
    }
    
    public func getCloudTexture() -> SKTexture {
        return SKTexture(imageNamed: self.getCloudTextureImageName())
    }
}
