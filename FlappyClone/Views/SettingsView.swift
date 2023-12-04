import SwiftUI

struct SettingsView: View {
    
    // MARK: View Body
    public var body: some View {
        TabView {
            AppSettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("App")
                }
            GameSettingsView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Game")
                }
            VisualSettingsView()
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Visual")
                }
        }
        .tint(.purple)
    }
}

// MARK: Previews
#Preview {
    SettingsView()
}
