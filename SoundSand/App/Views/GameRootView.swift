import SwiftUI

struct GameRootView: View {
    @StateObject private var GaneVM = GameViewModel()
    @State private var showWinScene = false
    @State private var navigateToContentView = false
    @State private var showTutorial = true
    @State private var showScene = false
    
    var body: some View {
 //       if showTutorial {
//            TutorialView {
//                showTutorial = false
//                showScene = true
//            }
//        } else if showScene {
//            WinSceneView(videoName: "IntroScene") {
//                showScene = false
//            }
/*        } else */ if navigateToContentView {
            ContentView() //Menu page -> Ghada's page
        } else if showWinScene {
            WinSceneView(videoName: "Win") {
                navigateToContentView = true
            }
        } else {
            GameView(GaneVM: GaneVM) {
                showWinScene = true
            }
        }
    }
}

#Preview {
    GameRootView()
}
