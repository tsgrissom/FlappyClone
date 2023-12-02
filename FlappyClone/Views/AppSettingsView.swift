import SwiftUI

// TODO Reset all button
struct AppSettingsView: View {
    
    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    @State private var isConfirmResetAllOptionsPresented: Bool = false
    
    @State private var audioMuted:      Bool = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    @State private var hapticsDisabled: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled)
    
    // MARK: Helper Functions
    private func resetAll() {
        defaults.setValue(false, forKey: DefaultsKey.AudioMuted)
        defaults.setValue(false, forKey: DefaultsKey.HapticsDisabled)
        audioMuted = false
        hapticsDisabled = false
    }
    
    // MARK: View Body
    public var body: some View {
        ScrollView {
            header
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionToggles
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
        }
    }
    
    // MARK: Sections
    private var header: some View {
        VStack {
            HStack {
                Text("App Settings")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            HStack {
                buttonReset
                Spacer()
            }
            .padding(.top, 1)
        }
    }
    
    private var sectionToggles: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Toggles")
                .font(.title2)
                .bold()
            HStack {
                Text("Audio muted")
                Toggle(isOn: $audioMuted) {}
                    .toggleStyle(.switch)
                    .onChange(of: audioMuted, initial: false) { oldValue, newValue in
                        print("Altered setting AudioMuted (\(oldValue)->\(newValue))")
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.AudioMuted)
                    }
            }
            HStack {
                Text("Haptics disabled")
                Toggle(isOn: $hapticsDisabled) {}
                    .toggleStyle(.switch)
                    .onChange(of: hapticsDisabled, initial: false) { oldValue, newValue in
                        print("Altered setting HapticsDisabled (\(oldValue)->\(newValue))")
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.HapticsDisabled)
                    }
            }
        }
    }
    
    // MARK: Complex Elements
    private var buttonReset: some View {
        Button(action: {
            self.isConfirmResetAllOptionsPresented = true
        }) {
            Text("Reset all options")
        }
        .alert("Reset all app settings?", isPresented: $isConfirmResetAllOptionsPresented) {
            Button(role: .destructive, action: resetAll) {
                Text("Confirm")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All app settings will be restored to their default values.")
        }
    }
}

// MARK: Previews
#Preview {
    AppSettingsView()
}
