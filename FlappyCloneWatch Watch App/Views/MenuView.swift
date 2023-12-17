import SwiftUI
import UIKit
import WatchKit

private struct PlayButton: View {
    
    @State private var isPressed = false
    
    public var body: some View {
        NavigationLink(value: 1) {
            ZStack {
                Circle()
                    .fill(isPressed ? .white : .yellow)
                    .frame(width: 100, height: 100)
                Image(systemName: "play.fill")
                    .font(.largeTitle)
                    .foregroundStyle(isPressed ? .black : .white)
            }
        }
        .clipShape(Circle())
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                WKInterfaceDevice.current().play(.click)
                self.isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isPressed = false
                }
            }
        )
    }
}

private struct AudioToggleUnmuted: View {
    
    public var body: some View {
        ZStack {
            Image(systemName: "speaker.wave.1")
                .foregroundStyle(.black)
        }
    }
}

private struct AudioToggleMuted: View {
    
    public var body: some View {
        ZStack {
            Image(systemName: "speaker")
                .foregroundStyle(.black)
            Image(systemName: "line.diagonal")
                .foregroundStyle(.red)
                .bold()
        }
    }
}

private struct SettingsButton: View {

    @State private var debouncePress = false
    @State private var isPressed     = false
    
    public var body: some View {
        NavigationLink(value: 2) {
            Image(systemName: "gear")
                .rotationEffect(.degrees(isPressed ? 360 : 0))
        }
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                isPressed = true
                doRotateEffect()
            }
        )
        .foregroundStyle(.black)
        .background(.white)
        .clipShape(Capsule())
    }
    
    private func doRotateEffect() {
        if debouncePress {
            return
        }
        
        debouncePress = true
        withAnimation(.linear(duration: 0.65)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            debouncePress = false
            isPressed = false
        }
    }
}

struct MenuView: View {
    
    @State private var isAudioMuted = false
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PlayButton()
                    Spacer()
                    HStack {
                        btnAudioToggle
                        SettingsButton()
                    }
                    .padding(.horizontal)
                }
            }
            .background(content: {
                Image("BG-Day")
            })
            .navigationDestination(for: Int.self) { value in
                if value == 1 {
                    GameView()
                } else if value == 2 {
                    SettingsView()
                }
            }
        }
    }
    
    private var btnPlay: some View {
        NavigationLink(value: 1) {
            PlayButton()
        }
    }
    
    private var btnAudioToggle: some View {
        Button(action: {
            WKInterfaceDevice.current().play(.click)
            isAudioMuted.toggle()
        }) {
            if isAudioMuted {
                AudioToggleMuted()
            } else {
                AudioToggleUnmuted()
            }
        }
        .background(.white)
        .clipShape(Capsule())
    }
}

#Preview("Main View") {
    MenuView()
}

#Preview("Audio Toggle Button") {
    AudioToggleUnmuted()
}

#Preview("Audio Toggle Muted Button") {
    AudioToggleMuted()
}

#Preview("Play Button") {
    PlayButton()
}

#Preview("Settings Button") {
    SettingsButton()
}
