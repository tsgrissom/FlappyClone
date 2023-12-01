import Foundation

enum GameSceneSetting: CaseIterable {
    
    public static func randomValue() -> GameSceneSetting {
        return self.allCases.randomElement() ?? .Day
    }
    
    public static func getPreferredSceneSetting() -> GameSceneSetting {
        let option = UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting)
        let allCases = GameSceneSetting.allCases
        let def: GameSceneSetting = .Day
        return if option == "Random" {
            randomValue()
        } else if option == "Day" {
            allCases
                .filter { it in it.isLight() }
                .randomElement() ?? def
        } else if option == "Night" {
            allCases
                .filter { it in it.isDark() }
                .randomElement() ?? def
        } else {
            def
        }
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
