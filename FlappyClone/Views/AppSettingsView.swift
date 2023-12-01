import SwiftUI

struct AppSettingsView: View {
    
    private let defaults = UserDefaults.standard
    
    @State private var audioMuted: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.AudioMuted)
    @State private var hapticsDisabled: Bool = UserDefaults.standard.bool(forKey: DefaultsKey.HapticsDisabled)
    @State private var preferredSceneSetting: String = UserDefaults.standard.string(forKey: DefaultsKey.PreferredSceneSetting) ?? "Random"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("App Settings")
                    .font(.largeTitle)
                    .bold()
                Divider()
                    .padding(.bottom, 15)
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
                        UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.PreferredSceneSetting)
                    }
                }
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
            .padding([.top, .horizontal], 20)
        }
    }
}

#Preview {
    AppSettingsView()
}
