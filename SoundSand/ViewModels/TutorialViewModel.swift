import Foundation
import SwiftUI
import AVFoundation

class TutorialViewModel :ObservableObject{
    init() {
        print("FUCK")
        self.gameTimeRemaining = 10
        self.gameDuration = 10
        self.currentLane = 1
        //            self.currentLevel = 0
        
        playBackgroundSound(backgroundSound)
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
    //        var currentLevel: Int
    
    
    @Published var  stopTimers: [String: Timer] = [:]
    @Published var  dialogPlayer: AVAudioPlayer?
    @Published var  obstaclePlayer: AVAudioPlayer?
    @Published var  backgroundAudioPlayer: AVAudioPlayer?
    
    @Published var  backgroundSound: String = "backgroundSound"
    
    let tutorialObstacles: [Obstacles] = [
        Obstacles(levelNo: 0, obstacleLane: 0, obstacleTimer: 0, obstcaleApperance: 4, obstacleSound: [
            ObstacleSound(obstacleSoundName: "rightLane", laneNo: 0, soundStatus: true),
            ObstacleSound(obstacleSoundName: "dogBarking", laneNo: 1, soundStatus: false),
            ObstacleSound(obstacleSoundName: "leftLane", laneNo: 2, soundStatus: false)
        ]),
        Obstacles(levelNo: 1, obstacleLane: 2, obstacleTimer: 0, obstcaleApperance: 6, obstacleSound: [
            ObstacleSound(obstacleSoundName: "dogBarking", laneNo: 0, soundStatus: true),
            ObstacleSound(obstacleSoundName: "dogBarking", laneNo: 1, soundStatus: false),
            ObstacleSound(obstacleSoundName: "dogBarking", laneNo: 2, soundStatus: false)
        ])
        //            ,
        //            Obstacles(levelNo: 2, obstacleLane: 2, obstacleTimer: 3, obstcaleApperance: 30, obstacleSound: [
        //                ObstacleSound(obstacleSoundName: "rightLane", laneNo: 0, soundStatus: true),
        //                ObstacleSound(obstacleSoundName: "middleLane", laneNo: 1, soundStatus: false),
        //                ObstacleSound(obstacleSoundName: "leftLane", laneNo: 2, soundStatus: false)
        //            ]),
    ]
    
    let tutrioalDialog: [DialogModel] = [
        DialogModel(dialogSoundName: "tutLeft", dialogApperance: 0),
        DialogModel(dialogSoundName: "tutRight", dialogApperance: 4),
        DialogModel(dialogSoundName: "tutLeft", dialogApperance: 6),
    ]
    
    
    
    
    
    func handleSwipe(direction: SwipeDirection) {
        switch direction {
        case .left:
            if currentLane > 0 {
                currentLane -= 1
                if showLeftArrow {
                    hideArrows("left")
                    stopSound(for: &obstaclePlayer)
                    resumeGameTimer()
                }
            }
        case .right:
            if currentLane < 2 {
                currentLane += 1
                if showRightArrow {
                    hideArrows("right")
                    stopSound(for: &obstaclePlayer)
                    resumeGameTimer()
                }
            }
        }
    }
    
    
    
    
    func playBackgroundSound(_ soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1
                backgroundAudioPlayer?.play()
            } catch {
                print("Failed to play background sound")
            }
        }
    }
    
    
    
    func playSound(named soundName: String, player: inout AVAudioPlayer?, duration: TimeInterval? = nil,_ soundInLoop: Bool = false) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                player = audioPlayer
                audioPlayer.play()
                if let duration = duration {
                    let playerKey = "\(Unmanaged.passUnretained(audioPlayer).toOpaque())"
                    stopTimers[playerKey]?.invalidate()
                    stopTimers[playerKey] = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak audioPlayer] _ in
                        audioPlayer?.stop()
                    }
                }
                if soundInLoop {
                    audioPlayer.numberOfLoops = -1
                }
            } catch {
                print("Failed to play sound: \(soundName), Error: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found: \(soundName).wav")
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
        stopSound(for: &backgroundAudioPlayer)
    }
    
    func checkDialogAppearance() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for dialog in tutrioalDialog {
            if Int(dialog.dialogApperance) == Int(elapsedTime) {
                playSound(named: dialog.dialogSoundName, player: &dialogPlayer)
            }
        }
    }
    
    func stopSound(for player: inout AVAudioPlayer?) {
        player?.stop()
        player = nil
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
                    playSound(named: sound.obstacleSoundName, player: &obstaclePlayer, true)
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

