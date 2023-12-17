import SpriteKit
import SwiftUI
import UIKit

struct GameView: View {
    
    var body: some View {
        createGameSceneSpriteView()
    }
    
    private func createGameSceneSpriteView() -> some View {
        let scene = SKScene(fileNamed: "GameScene")!
        scene.scaleMode = .resizeFill
        return SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
