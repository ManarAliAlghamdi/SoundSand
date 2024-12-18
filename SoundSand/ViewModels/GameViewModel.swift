import Foundation
import UIKit
import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var player = PlayerModel()
    @Published var obstacles: [ObstacleModel] = []
    @Published var gameOver = false
    @Published var gameTimeRemaining: TimeInterval
    
    private let maxLineIndex = 2
    private let minLineIndex = 0
    private var gameTimer: Timer?
    private var spawnTimer: Timer?
    private var gameDuration: TimeInterval
    private var currentSpeed: CGFloat
    private let soundManager = SoundManager()
    private var obstacleSpawnData: [ObstacleSpawnData] = [
        ObstacleSpawnData(
                line: 0,
                spawnTime: 5,
                soundFileName: "left.mp3",
                soundDelay: 3,
                duration: 5
            ),
//        ObstacleSpawnData(line: 1, spawnTime: 3, soundFileName: "middle.mp3", soundDelay: 0.3),
//        ObstacleSpawnData(line: 2, spawnTime: 5, soundFileName: "right.mp3", soundDelay: 0.7),
//        ObstacleSpawnData(line: 0, spawnTime: 10, soundFileName: "left.mp3", soundDelay: 0.4)
    ]
    
    
    init() {
            self.gameDuration = 60
            self.gameTimeRemaining = 60
            self.currentSpeed = 8
            self.obstacleSpawnData 
            startGame()
        }

    func startGame() {
        setupGameTimer()
        setupSpawnTimer()
    }
    
    private func setupGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.gameTimeRemaining > 0 {
                self.gameTimeRemaining -= 1
            } else {
                self.stopGame()
                self.gameOver = true
            }
        }
    }
    
    private func setupSpawnTimer() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.updateGame()
            self.checkObstacleSpawns()
        }
    }

    private func checkObstacleSpawns() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for spawn in obstacleSpawnData {
            if abs((spawn.spawnTime - spawn.soundDelay) - elapsedTime) < 0.016 {
                playSoundBeforeObstacle(spawn: spawn)
            }
        }
    }

    private func playSoundBeforeObstacle(spawn: ObstacleSpawnData) {
        self.soundManager.playSound(named: spawn.soundFileName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + spawn.soundDelay) {
            let creationTime = self.gameDuration - self.gameTimeRemaining
            let newObstacle = ObstacleModel(
                line: spawn.line,
                yPosition: 0,
                creationTime: creationTime,
                duration: spawn.duration
            )
            print("Obstacle Created: \(newObstacle.id), Creation Time: \(creationTime), Duration: \(newObstacle.duration)")
            self.obstacles.append(newObstacle)
        }
    }


    func updateGame() {
        guard !gameOver else { return }

        let currentTime = gameDuration - gameTimeRemaining

        obstacles.removeAll { obstacle in
            let obstacleAge = currentTime - obstacle.creationTime
            print("Obstacle ID: \(obstacle.id), Age: \(obstacleAge), Duration: \(obstacle.duration)")
            return obstacleAge >= obstacle.duration || obstacle.yPosition > UIScreen.main.bounds.height
        }

        for index in obstacles.indices {
            obstacles[index].yPosition += currentSpeed
        }

        checkCollisions()
    }


    func stopGame() {
        gameTimer?.invalidate()
        spawnTimer?.invalidate()
    }

    func checkCollisions() {
        for obstacle in obstacles {
            if obstacle.line == player.currentLine &&
                abs(obstacle.yPosition - (UIScreen.main.bounds.height - 15)) < 15 {
                gameOver = true
                stopGame()
            }
        }
    }
    
    
    func moveLeft() {
        guard player.currentLine > minLineIndex else { return }
        player.currentLine -= 1
    }
    
    func moveRight() {
        guard player.currentLine < maxLineIndex else { return }
        player.currentLine += 1
    }
    
    
    func xOffset(for line: Int, width: CGFloat) -> CGFloat {
        
        let lineSpacing: CGFloat = 135
        let offset = CGFloat(line - 1) * lineSpacing
        return offset
    }

}
