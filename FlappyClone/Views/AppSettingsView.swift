import SwiftUI

struct AppSettingsView: View {
    
    private let defaults = UserDefaults.standard
    
    @State private var audioMuted:      Bool = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    @State private var hapticsDisabled: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled)
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("App Settings")
                    .font(.largeTitle)
                    .bold()
                Divider()
                    .padding(.bottom, 15)
                sectionAppSettings
            }
            .padding([.top, .horizontal], 20)
        }
    }
    
    private var sectionAppSettings: some View {
        Section {
            Text("Toggles")
                .font(.title3)
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
