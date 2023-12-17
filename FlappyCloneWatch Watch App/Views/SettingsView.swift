import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            ForEach(1...10, id: \.self) { _ in
                Text("Hello world")
            }
        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    SettingsView()
}
