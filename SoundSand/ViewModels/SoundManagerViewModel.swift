import AVFoundation

class SoundManager {
    
    private var currentPlayer: AVAudioPlayer?
    private let soundFiles: [[String]] = [
        ["left.mp3", "middle.mp3", "right.mp3"],
        ["low.mp3", "mid.mp3", "high.mp3"]
    ]

    func playPositionalSound(forLine obstacleLine: Int, playerLine: Int, soundIndex: Int, duration: TimeInterval) {
        stopCurrentSound()
        
        guard soundIndex >= 0, soundIndex < soundFiles.count else { return }
        let soundArray = soundFiles[soundIndex]
        
        guard playerLine >= 0, playerLine < soundArray.count else { return }
        let soundToPlay = soundArray[playerLine]

        playSound(named: soundToPlay, duration: duration)
    }
    
    func playCollisionSound(named fileName: String, duration: TimeInterval) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            currentPlayer = player
            player.currentTime = 0
            player.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if player.isPlaying {
                    player.stop()
                }
            }
        } catch {
            print("err: \(error.localizedDescription)")
        }
    }



    private func playSound(named fileName: String, duration: TimeInterval) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            currentPlayer = player
            player.currentTime = 0
            player.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if player.isPlaying {
                    player.stop()
                }
            }
        } catch {
            print("err: \(error.localizedDescription)")
        }
    }


    func stopCurrentSound() {
        currentPlayer?.stop()
        currentPlayer = nil
    }
}
