import AVFoundation
import UIKit

class SoundManager {
    
    private let soundFiles: [[String]] = [
        ["left.mp3", "middle.mp3", "right.mp3"],
        ["low.mp3", "mid.mp3", "high.mp3"]
    ]
    
    var  dialogPlayer: AVAudioPlayer?
    var  obstaclePlayer: AVAudioPlayer?
    var  backgroundAudioPlayer: AVAudioPlayer?
    var  collisionAudioPlayer: AVAudioPlayer?
    
    var  stopTimers: [String: Timer] = [:]
    
    
//    
//    func playSoundBeforeObstacle(
//        obstacle: ObstacleModel,
//        player: PlayerModel,
//        gameDuration: TimeInterval,
//        timeRemaining: TimeInterval,
//        yPosition: CGFloat,
//        onObstacleCreated: @escaping (ObstacleModel) -> Void
//    ) {
//        let remainingDuration = max(0, obstacle.soundDelay)
//        
//        // Play the sound
//        self.playPositionalSound(
//            forLine: obstacle.line,
//            playerLine: player.currentLine,
//            soundIndex: obstacle.soundIndex,
//            duration: remainingDuration
//        )
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + obstacle.soundDelay) { [weak self] in
//            guard let self = self else { return }
//            
//            let creationTime = gameDuration - timeRemaining
//            
//            var newObstacle = obstacle
//            newObstacle.yPosition = UIScreen.main.bounds.height - 100
//            newObstacle.appearenceTime = creationTime
//            
//            // Notify the caller to append the obstacle
//            onObstacleCreated(newObstacle)
//        }
//    }

    
     func playSoundBeforeObstacle(
        obstacle: ObstacleModel,
        player: PlayerModel,
        gameDuration: TimeInterval,
        gameTimeRemaining: TimeInterval)-> ObstacleModel?  {
        let remainingDuration = max(0, obstacle.soundDelay)
        
        playPositionalSound(
            forLine: obstacle.line,
            playerLine: player.currentLine,
            soundIndex: obstacle.soundIndex,
            duration: remainingDuration
        )
        
        var newObstacle: ObstacleModel?
        DispatchQueue.main.asyncAfter(deadline: .now() + obstacle.soundDelay) { [weak self] in
            guard let self = self else { return }
            let creationTime = gameDuration - gameTimeRemaining
            
            var updatedObstacle = obstacle
            updatedObstacle.yPosition = UIScreen.main.bounds.height - 100
            updatedObstacle.appearenceTime = creationTime
            newObstacle = updatedObstacle
        }
            return newObstacle
    }
    
    
    func playPositionalSound(forLine obstacleLine: Int, playerLine: Int, soundIndex: Int, duration: TimeInterval) {
        guard soundIndex >= 0, soundIndex < soundFiles.count else { return }
        let soundArray = soundFiles[soundIndex]
        
        guard playerLine >= 0, playerLine < soundArray.count else { return }
        let soundToPlay = soundArray[playerLine]
        
        playSound(named: soundToPlay, player: &obstaclePlayer, stopTimers: &stopTimers)
    }
    
    
    
    func playSound(named soundName: String, player: inout AVAudioPlayer?, duration: TimeInterval? = nil,soundInLoop: Bool = false, stopTimers: inout [String: Timer]) {
        if let path = Bundle.main.path(forResource: soundName, ofType: nil) {
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
            print("Sound file not found: \(soundName)")
        }
    }
    
    
    func stopAllSounds(){
        dialogPlayer?.stop()
        backgroundAudioPlayer?.stop()
        obstaclePlayer?.stop()
        collisionAudioPlayer?.stop()

    }
    
    func stopSound(for player: inout AVAudioPlayer?) {
        player?.stop()
        player = nil
    }
    
    func getSoundDuration(fileName: String) -> TimeInterval? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sound file not found: \(fileName)")
            return nil
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            return audioPlayer.duration
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
            return nil
        }
    }
    
    
}


