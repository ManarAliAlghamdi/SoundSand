import SwiftUI

struct GameView: View {
    @StateObject private var GaneVM = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            
                Circle()
                    .fill(Color.white)
                    .frame(width: 30, height: 30)
                    .position(x: geometry.size.width / 2 + GaneVM.xOffset(for: GaneVM.player.currentLine, width: geometry.size.width),
                              y: geometry.size.height - 15)
                
                ForEach(GaneVM.obstacles) { obstacle in
                    if !GaneVM.gameOver {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                            .position(
                                x: geometry.size.width / 2 + GaneVM.xOffset(for: obstacle.line, width: geometry.size.width),
                                y: obstacle.yPosition - 15
                            )
                    }
                }
                
                if GaneVM.gameOver {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }

                VStack {
                    Spacer()
                    Text("Time Remaining: \(Int(GaneVM.gameTimeRemaining)) seconds")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            //print(value.translation.width)
                            GaneVM.moveLeft()
                        } else if value.translation.width > 0 {
                            //print(value.translation.width)
                            GaneVM.moveRight()
                        }
                    }
            )
        }
    }
}

#Preview {
    GameView()
}
