import SwiftUI

// TODO Reset all button
struct GameSettingsView: View {
    
    private let defaults = UserDefaults.standard
    
    @State private var isConfirmClearScorePresented      = false
    @State private var isNoHighScoreToClearPresented     = false
    @State private var isConfirmResetAllOptionsPresented = false
    
    @State private var preferredSceneSetting: String = UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting) ?? "Random"
    @State private var dieOnOutOfBounds: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnOutOfBounds)
    @State private var dieOnHitBoundary: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnHitBoundary)
    @State private var dieOnHitWall:     Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnHitWall)
    @State private var numberOfWallHits: Int  = UserDefaults.standard.integer(forKey: DefaultsKey.NumberOfWallHitsAllowed)
    
    private func resetAll() {
        defaults.setValue("Random", forKey: DefaultsKey.PreferredSceneSetting)
        defaults.setValue(true, forKey: DefaultsKey.DieOnOutOfBounds)
        defaults.setValue(false, forKey: DefaultsKey.DieOnHitBoundary)
        defaults.setValue(false, forKey: DefaultsKey.DieOnHitWall)
        defaults.setValue(0, forKey: DefaultsKey.NumberOfWallHitsAllowed)
        
        preferredSceneSetting = "Random"
        dieOnOutOfBounds = true
        dieOnHitBoundary = false
        dieOnHitWall = false
        numberOfWallHits = 0
    }
    
    private func clearHighScore() {
        defaults.setValue(0, forKey: DefaultsKey.HighScore)
        if !defaults.bool(forKey: DefaultsKey.HapticsDisabled) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    private var highestScore: Int {
        defaults.integer(forKey: DefaultsKey.HighScore)
    }
    
    public var body: some View {
        ScrollView {
            header
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionBase
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionDifficulty
                .padding(.horizontal, 20)
        }
    }
    
    private var resetButton: some View {
        Button(action: {
            self.isConfirmResetAllOptionsPresented = true
        }) {
            Text("Reset all options")
        }
        .alert("Reset all game settings?", isPresented: $isConfirmResetAllOptionsPresented) {
            Button(role: .destructive, action: resetAll) {
                Text("Confirm")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All game settings will be restored to their default values.")
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Text("Game Settings")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            HStack {
                resetButton
                Spacer()
            }
            .padding(.top, 1)
        }
    }
    
    private var sectionBase: some View {
        VStack(alignment: .leading, spacing: 0) {
            pickerPreferredScene
            
            HStack {
                Text("High score: \(highestScore)")
                Spacer()
                buttonClearHighScore
            }
        }
    }
    
    private var sectionDifficulty: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Difficulty")
                .font(.title2)
                .bold()
            HStack {
                Text("Allowed wall hits: \(numberOfWallHits)")
                Stepper(value: $numberOfWallHits, in: 0...3) {}
                    .onChange(of: numberOfWallHits, initial: false) { oldValue, newValue in
                        print("Altered setting NumberOfWallHitsAllowed (\(oldValue)->\(newValue))")
                        defaults.setValue(newValue, forKey: DefaultsKey.NumberOfWallHitsAllowed)
                        dieOnHitWall = true
                        defaults.setValue(true, forKey: DefaultsKey.DieOnHitWall)
                    }
            }
            HStack {
                Text("Die on out of bounds")
                Toggle(isOn: $dieOnOutOfBounds) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnOutOfBounds, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnOutOfBounds (\(oldValue)->\(newValue))")
                        defaults.setValue(newValue, forKey: DefaultsKey.DieOnHitBoundary)
                    }
            }
            HStack {
                Text("Die on hit boundary (Upper/Lower)")
                Toggle(isOn: $dieOnHitBoundary) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnHitBoundary, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnHitBoundary (\(oldValue)->\(newValue))")
                        defaults.setValue(newValue, forKey: DefaultsKey.DieOnHitBoundary)
                    }
            }
            HStack {
                Text("Die on hit wall")
                Toggle(isOn: $dieOnHitWall) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnHitWall, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnHitWall (\(oldValue)->\(newValue))")
                        defaults.setValue(newValue, forKey: DefaultsKey.DieOnHitWall)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var buttonClearHighScore: some View {
        if highestScore > 0 {
            Button(action: {
                self.isConfirmClearScorePresented = true
            }) {
                Image(systemName: "trash")
            }
            .alert("Reset your high score?", isPresented: $isConfirmClearScorePresented) {
                Button(role: .destructive, action: clearHighScore) {
                    Text("Confirm")
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to reset your high score of \(highestScore) to 0?")
            }
            .buttonStyle(.bordered)
            .tint(.red)
        } else {
            Button(action: {
                self.isNoHighScoreToClearPresented = true
            }) {
                Image(systemName: "trash")
            }
            .alert("Nothing to reset", isPresented: $isNoHighScoreToClearPresented) {
                Button(role: .cancel, action: {}) {
                    Text("Okay")
                }
            } message: {
                Text("You do not have a high score to reset. Get flapping!")
            }
            .buttonStyle(.bordered)
            .tint(.gray)
        }
    }
    
    private var pickerPreferredScene: some View {
        HStack {
            Text("Preferred scene")
            Spacer()
            Picker(selection: $preferredSceneSetting, content: {
                Text("Random").tag("Random")
                Text("Day").tag("Day")
                Text("Night").tag("Night")
            }, label: {})
            .onChange(of: preferredSceneSetting, initial: false) { oldValue, newValue in
                print("Altered setting PreferredSceneSetting (\"\(oldValue)\"->\"\(newValue)\")")
                defaults.setValue(newValue, forKey: DefaultsKey.PreferredSceneSetting)
            }
            
        }
    }
}

#Preview {
    GameSettingsView()
}
