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

        if let url = Bundle.main.url(forResource: soundToPlay, withExtension: nil) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                currentPlayer = player
                player.play()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.stopCurrentSound()
                }
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }

    func stopCurrentSound() {
        currentPlayer?.stop()
        currentPlayer = nil
    }
    

}
