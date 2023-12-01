import SwiftUI

struct GameSettingsView: View {
    
    @State private var isConfirmClearScorePresented: Bool = false
    
    @State private var dieOnOutOfBounds: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnOutOfBounds)
    @State private var dieOnHitBoundary: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnHitBoundary)
    @State private var dieOnHitWall:     Bool = UserDefaults.standard.bool(forKey: DefaultsKey.DieOnHitWall)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Game Settings")
                    .font(.largeTitle)
                    .bold()
                Divider()
                    .padding(.bottom, 15)
                sectionDifficulty
            }
            .padding([.top, .horizontal], 20)
        }
    }
    
    private var sectionDifficulty: some View {
        let highestScore = UserDefaults.standard.integer(forKey: DefaultsKey.HighScore)
        return Section {
            Button(action: {
                self.isConfirmClearScorePresented = true
            }) {
                Image(systemName: "xmark")
                Text("Clear high score")
            }
            .alert("Reset your high score?", isPresented: $isConfirmClearScorePresented) {
                Button(role: .destructive, action: clearHighScore) {
                    Text("Confirm")
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to reset your high score of \(highestScore) to 0?")
            }
            .font(.title3)
            .buttonStyle(.bordered)
            .tint(.red)
            .padding(.bottom, 15)
            Text("Difficulty")
                .font(.title3)
                .bold()
            HStack {
                Text("Die on out of bounds")
                Toggle(isOn: $dieOnOutOfBounds) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnOutOfBounds, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnOutOfBounds (\(oldValue)->\(newValue))")
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.DieOnHitBoundary)
                    }
            }
            HStack {
                Text("Die on hit boundary (Upper/Lower)")
                Toggle(isOn: $dieOnHitBoundary) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnHitBoundary, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnHitBoundary (\(oldValue)->\(newValue))")
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.DieOnHitBoundary)
                    }
            }
            HStack {
                Text("Die on hit wall")
                Toggle(isOn: $dieOnHitWall) {}
                    .toggleStyle(.switch)
                    .onChange(of: dieOnHitWall, initial: false) { oldValue, newValue in
                        print("Altered setting DieOnHitWall (\(oldValue)->\(newValue))")
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.DieOnHitWall)
                    }
            }
        }
    }
    
    private func clearHighScore() {
        UserDefaults.standard.setValue(0, forKey: DefaultsKey.HighScore)
        if !UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

#Preview {
    GameSettingsView()
}
