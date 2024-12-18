//
//  TutorialView.swift
//  SoundSand
//
//  Created by Manar Alghmadi on 16/12/2024.
//

import SwiftUI

/// SwiftUI View to display the game tutorial.
struct TutorialView: View {
    @ObservedObject var viewModel = TutorialViewModel()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Dark background.

            VStack {
                Text("Lane: \(viewModel.currentLane)") // Display the current lane for debugging.
                    .foregroundColor(.white)
                    .padding()

                Spacer()
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
