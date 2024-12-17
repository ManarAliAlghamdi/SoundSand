import Foundation
import SwiftUI
import AVFoundation

// ViewModel to manage the game logic for the tutorial.
class TutorialViewModel: ObservableObject {
    @Published var currentLane: Int = 1 // The player starts in the middle lane (0 = left, 1 = center, 2 = right).
    private var audioPlayer: AVAudioPlayer?

    init() {
        playInitialLaneSound() // Play the middle lane sound on app launch.
    }

    // Method to handle swipes and update the current lane.
    func handleSwipe(direction: SwipeDirection) {
        switch direction {
        case .left:
            if currentLane > 0 {
                currentLane -= 1 // Move to the left lane.
                playLaneSound()
            }
        case .right:
            if currentLane < 2 {
                currentLane += 1 // Move to the right lane.
                playLaneSound()
            }
        }
    }

    // Method to play the sound for the current lane.
    private func playLaneSound() {
        let soundName: String
        switch currentLane {
        case 0:
            soundName = "leftLane"
        case 1:
            soundName = "middleLane"
        case 2:
            soundName = "rightLane"
        default:
            return
        }
        
        playSound(named: soundName)
    }

    // Plays the sound for the initial middle lane on app launch.
    private func playInitialLaneSound() {
        playSound(named: "middleLane")
    }

    // Helper method to play a sound file.
    private func playSound(named soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play sound for lane: \(soundName)")
            }
        }
    }
}

// Enum to represent swipe directions.
enum SwipeDirection {
    case left
    case right
}
