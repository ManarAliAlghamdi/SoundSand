import SwiftUI

struct WinSceneView: View {
    let videoName: String
    let onVideoEnd: () -> Void
    
    var body: some View {
        VideoPlayerView(videoName: videoName, onVideoEnd: onVideoEnd)
            .edgesIgnoringSafeArea(.all)
    }
}
