import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    public static func getRandomDaytimeSceneSetting() -> GameSceneSetting {
        GameSceneSetting.allCases
            .filter { it in it.isLight() }
            .randomElement() ?? .Day
    }
    
    public static func getRandomNighttimeSceneSetting() -> GameSceneSetting {
        GameSceneSetting.allCases
            .filter { it in it.isDark() }
            .randomElement() ?? .Night
    }
    
    public static func getPreferredSceneSetting() -> GameSceneSetting {
        return switch (UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting)) {
        case "Random":
            randomValue()
        case "Day":
            getRandomDaytimeSceneSetting()
        case "Night":
            getRandomNighttimeSceneSetting()
        default:
            GameSceneSetting.Day
        }
    }
    
    case Day, Day2, Day3, Night, Night2, Night3
    
    public func isLight() -> Bool {
        return switch (self) {
        case .Day, .Day2, .Day3:
            true
        case .Night, .Night2, .Night3:
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
        case .Night2:
            "BG-Night2"
        case .Night3:
            "BG-Night3"
        }
    }
    
    public func getCloudTextureImageName() -> String {
        return switch (self) {
        case .Day, .Day2, .Day3:
            "Clouds-Day"
        case .Night, .Night2:
            "Clouds-Night"
        case .Night3:
            "Clouds-Gray"
        }
    }
}
