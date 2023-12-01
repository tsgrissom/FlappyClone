import SwiftUI

struct SettingsView: View {
    var body: some View {
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
        }
//        .tint(.yellow)
    }
}

#Preview {
    SettingsView()
}
