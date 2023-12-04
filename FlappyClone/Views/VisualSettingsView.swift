import SwiftUI

struct VisualSettingsView: View {
    
    private let defaults = UserDefaults.standard
    
    @State private var isConfirmResetAllOptionsPresented = false
    
    @State private var preferredSceneSetting: String = UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting) ?? "Random"
    
    private func resetAll() {
        defaults.setValue("Random", forKey: DefaultsKey.PreferredSceneSetting)
        preferredSceneSetting = "Random"
    }
    
    public var body: some View {
        ScrollView {
            sectionHeader
                .padding(.top, 10)
                .padding(.horizontal, 20)
            sectionBase
                .padding(.top, 10)
                .padding(.horizontal, 20)
        }
    }
    
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
    
    private var sectionBase: some View {
        VStack(alignment: .leading, spacing: 0) {
            pickerPreferredScene
        }
    }
    
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
    VisualSettingsView()
}
