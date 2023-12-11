import SwiftUI

struct VisualSettingsView: View {
    
    
    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    @State private var isConfirmResetAllOptionsPresented = false
    
    @State private var gamepadHintDisplayMode: String = UserDefaults.standard.string(forKey: DefaultsKey.GamepadDisplayMode) ?? GamepadHintDisplayMode.Dynamic.rawValue
    @State private var preferredGamepad: String = UserDefaults.standard.string(forKey: DefaultsKey.PreferredGamepad) ?? GamepadPreference.Dynamic.rawValue
    @State private var preferredSceneSetting: String = UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting) ?? "Random"
    
    // MARK: Helper Functions
    private func resetAll() {
        let defDisplayMode = GamepadHintDisplayMode.Dynamic.rawValue
        let defPreferredGamepad = GamepadPreference.Dynamic.rawValue
        let defPreferredSceneSetting = "Random"
        defaults.setValue(defDisplayMode, forKey: DefaultsKey.GamepadDisplayMode)
        defaults.setValue(defPreferredGamepad, forKey: DefaultsKey.PreferredGamepad)
        defaults.setValue(defPreferredSceneSetting, forKey: DefaultsKey.PreferredSceneSetting)
        
        gamepadHintDisplayMode = defDisplayMode
        preferredGamepad = defPreferredGamepad
        preferredSceneSetting = defPreferredSceneSetting
    }
    
    // MARK: View Body
    public var body: some View {
        ScrollView {
            sectionHeader
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionBase
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionGamepad
                .padding(.top, 10)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: Section Views
    private var sectionHeader: some View {
        VStack {
            HStack {
                Text("Visual Settings")
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
    
    private var sectionGamepad: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Gamepad")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            pickerGamepadPromptDisplayMode
            pickerPreferredGamepad
        }
    }
    
    private var sectionBase: some View {
        VStack(alignment: .leading, spacing: 0) {
            pickerPreferredScene
        }
    }
    
    // MARK: Subviews
    private var buttonReset: some View {
        Button(action: {
            self.isConfirmResetAllOptionsPresented = true
        }) {
            Text("Reset all options")
        }
        .alert("Reset all visual settings?", isPresented: $isConfirmResetAllOptionsPresented) {
            Button(role: .destructive, action: resetAll) {
                Text("Confirm")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All visual settings will be restored to their default values.")
        }
    }
    
    private var pickerGamepadPromptDisplayMode: some View {
        HStack {
            Text("Display prompts")
            Spacer()
            Picker(selection: $gamepadHintDisplayMode, content: {
                Text("Dynamic").tag(GamepadHintDisplayMode.Dynamic.rawValue)
                Text("Always").tag(GamepadHintDisplayMode.Always.rawValue)
                Text("Never").tag(GamepadHintDisplayMode.Never.rawValue)
            }, label: {})
            .onChange(of: preferredGamepad, initial: false) { oldValue, newValue in
                print("Altered setting GamepadDisplayMode (\"\(oldValue)\"->\"\(newValue)\")")
                defaults.setValue(newValue, forKey: DefaultsKey.GamepadDisplayMode)
            }
        }
    }
    
    private var pickerPreferredGamepad: some View {
        HStack {
            Text("Preferred gamepad")
            Spacer()
            Picker(selection: $preferredGamepad, content: {
                Text("Dynamic").tag(GamepadPreference.Dynamic.rawValue)
                Text("Sony").tag(GamepadPreference.Sony.rawValue)
                Text("Xbox").tag(GamepadPreference.Standard.rawValue)
            }, label: {})
            .onChange(of: preferredGamepad, initial: false) { oldValue, newValue in
                print("Altered setting PreferredGamepad (\"\(oldValue)\"->\"\(newValue)\")")
                defaults.setValue(newValue, forKey: DefaultsKey.PreferredGamepad)
            }
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

// MARK: Previews
#Preview {
    VisualSettingsView()
}
