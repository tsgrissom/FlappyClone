import Foundation

struct DefaultsKey {
    
    // Future
    // - Allowed number of hits (def 0)
    
    // Game Difficulty
    static let DieOnOutOfBounds      = "DifficultyDieOnOutOfBounds" // def true
    static let DieOnHitBoundary      = "DifficultyDieOnHitBoundary" // def false
    static let DieOnHitWall          = "DifficultyDieOnHitWall"     // def false
    
    // Game Data
    static let HighScore             = "GameHighScore" // def 0
    
    // App Settings
    static let AudioMuted            = "SettingAudioMuted"            // def false
    static let HapticsDisabled       = "SettingHapticsDisabled"       // def false
    static let PreferredSceneSetting = "SettingPreferredSceneSetting" // def "Random"
}
