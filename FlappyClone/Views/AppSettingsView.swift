import SwiftUI

struct AppSettingsView: View {
    
    private let defaults = UserDefaults.standard
    
    @State private var audioMuted:      Bool = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    @State private var hapticsDisabled: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled)
    
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
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text("App Settings")
                .font(.largeTitle)
                .bold()
            Divider()
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
}

#Preview {
    AppSettingsView()
}
