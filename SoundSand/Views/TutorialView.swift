import SwiftUI

struct TutorialView: View {
    @StateObject var viewModel = TutorialViewModel()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Lane: \(viewModel.currentLane)")
                
                    .foregroundColor(.white)
                    .padding()
                Text("timer: \(viewModel.tempTimer)")
                    .foregroundColor(.white)
                    .padding()
                
                if viewModel.showLeftArrow {
                    Image("leftArrow")
                        .resizable()
                        .frame(width: 100, height: 50)
                        .offset(x: viewModel.leftArrowOffset)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                viewModel.leftArrowOffset = -30
                            }
                        }
                        .transition(.opacity)
                    
                }else if viewModel.showRightArrow {
                    Image("rightArrow")
                        .resizable()
                        .frame(width: 100, height: 50)
                        .offset(x: viewModel.rightArrowOffset)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                viewModel.rightArrowOffset = -30
                            }
                        }
                        .transition(.opacity)
                }
                Spacer()
                
                if viewModel.gameOver {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    
                    if horizontalDistance < -50 { // Swipe left.
                        viewModel.handleSwipe(direction: .left)
                    } else if horizontalDistance > 50 { // Swipe right.
                        viewModel.handleSwipe(direction: .right)
                    }
                }
        )
    }
}



#Preview {
    TutorialView()
}
