import Foundation
import SwiftUI
import AVFoundation

class TutorialViewModel :ObservableObject{
    private let soundManager = SoundManager()
    init() {
        print("FUCK")
        self.gameTimeRemaining = 10
        self.gameDuration = 10
        self.currentLane = 1
        
        soundManager.playSound(named: "backgroundSound.wav", player: &soundManager.backgroundAudioPlayer, soundInLoop: true, stopTimers: &soundManager.stopTimers)
        
        setupGameTimer()
        
    }
    @Published var leftArrowOffset: CGFloat = 0
    @Published var rightArrowOffset: CGFloat = 0
    @Published var showLeftArrow: Bool = false
    @Published var  showRightArrow: Bool = false
    
    @Published var  gameTimeRemaining: TimeInterval
    @Published var  gameDuration :TimeInterval
    @Published var  gameTimer: Timer?
    @Published var  gameOver = false
    @Published var  tempTimer :TimeInterval = 0
    
    @Published var  currentLane: Int
    

    
    let tutorialObstacles: [Obstacles] = [
        Obstacles(levelNo: 0, obstacleLane: 0, obstacleTimer: 0, obstcaleApperance: 4, obstacleSound: [
            ObstacleSound(obstacleSoundName: "rightLane.wav", laneNo: 0, soundStatus: true),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 1, soundStatus: false),
            ObstacleSound(obstacleSoundName: "leftLane.wav", laneNo: 2, soundStatus: false)
        ]),
        Obstacles(levelNo: 1, obstacleLane: 2, obstacleTimer: 0, obstcaleApperance: 6, obstacleSound: [
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 0, soundStatus: true),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 1, soundStatus: false),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 2, soundStatus: false)
        ])
    ]
    
    let tutrioalDialog: [DialogModel] = [
        DialogModel(dialogSoundName: "tutLeft.wav", dialogApperance: 0),
        DialogModel(dialogSoundName: "tutRight.wav", dialogApperance: 4),
        DialogModel(dialogSoundName: "tutLeft.wav", dialogApperance: 6),
    ]
    
    
    
    
    
    func handleSwipe(direction: SwipeDirection) {
        switch direction {
        case .left:
            if currentLane > 0 {
                currentLane -= 1
                if showLeftArrow {
                    hideArrows("left")
                    soundManager.stopSound(for: &soundManager.obstaclePlayer)
                    resumeGameTimer()
                }
            }
        case .right:
            if currentLane < 2 {
                currentLane += 1
                if showRightArrow {
                    hideArrows("right")
                    soundManager.stopSound(for: &soundManager.obstaclePlayer)
                    resumeGameTimer()
                }
            }
        }
    }
    
    
    
    func setupGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.gameTimeRemaining > 0 {
                self.gameTimeRemaining -= 1
                self.tempTimer += 1
                self.checkDialogAppearance()
                self.checkObstacleAppearance()
            } else {
                self.stopGame()
                self.gameOver = true
            }
        }
    }
    
    
    func stopGame() {
        gameTimer?.invalidate()
        soundManager.stopSound(for: &soundManager.backgroundAudioPlayer)
    }
    
    func checkDialogAppearance() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for dialog in tutrioalDialog {
            if Int(dialog.dialogApperance) == Int(elapsedTime) {
                soundManager.playSound(named: dialog.dialogSoundName, player: &soundManager.dialogPlayer, stopTimers: &soundManager.stopTimers)
            }
        }
    }
    
    
    func checkObstacleAppearance() {
        let elapsedTime = gameDuration - gameTimeRemaining
        
        for obstacle in tutorialObstacles {
            if Int(obstacle.obstcaleApperance) == Int(elapsedTime) {
                if obstacle.obstacleLane == 0 && !showLeftArrow {
                    showLeftArrow = true
                    pauseGameTimer()
                } else if obstacle.obstacleLane == 2 && !showRightArrow {
                    showRightArrow = true
                    pauseGameTimer()
                }
                if let sound = obstacle.obstacleSound.first(where: { $0.laneNo == currentLane }) {
                    soundManager.playSound(named: sound.obstacleSoundName, player: &soundManager.obstaclePlayer, stopTimers: &soundManager.stopTimers)
                }
            }
        }
    }
    
    func pauseGameTimer() {
        gameTimer?.invalidate()
    }
    
    func resumeGameTimer() {
        setupGameTimer()
    }
    
    
    func hideArrows(_ leftOrRight: String) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                if leftOrRight == "left" {
                    self.showLeftArrow = false
                }else if leftOrRight == "right" {
                    self.showRightArrow = false
                }
            }
        }
    }
    
    enum SwipeDirection {
        case left
        case right
    }
    
}

