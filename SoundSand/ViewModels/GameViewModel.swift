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
    private var obstacleSpawnData: [ObstacleModel] = [
        ObstacleModel(
            line: 1,
            yPosition: UIScreen.main.bounds.height - 100,
            spawnTime: 10,
            soundDelay: 5,
            duration: 3,
            soundIndex: 0,
            collisionSound: "mid.mp3",
            collisionSoundDuration: 5
        ),
        ObstacleModel(
            line: 2,
            yPosition: UIScreen.main.bounds.height - 100,
            spawnTime: 20,
            soundDelay: 5,
            duration: 8,
            soundIndex: 1,
            collisionSound: "hit2.mp3",
            collisionSoundDuration: 1.5
        )
    ]
    
    init() {
        self.gameDuration = 60
        self.gameTimeRemaining = 60
        self.currentSpeed = 8
        startGame()
    }
    
    // MARK: - Game Lifecycle
    
    func startGame() {
        setupGameTimer()
        setupSpawnTimer()
    }
    
    func stopGame() {
        print("Stopping game...")
        gameTimer?.invalidate()
        spawnTimer?.invalidate()
        gameTimer = nil
        spawnTimer = nil
        gameOver = true
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
    
    
    // MARK: - Obstacles Manamgment
    
    private func setupSpawnTimer() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateGame()
            self.checkObstacleSpawns()
        }
    }
    
    private func checkObstacleSpawns() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for index in obstacleSpawnData.indices {
            var obstacle = obstacleSpawnData[index]
            if !obstacle.played && abs((obstacle.spawnTime - obstacle.soundDelay) - elapsedTime) < 0.016 {
                playSoundBeforeObstacle(obstacle: obstacle)
                obstacleSpawnData[index].played = true
            }
        }
    }
    
    private func playSoundBeforeObstacle(obstacle: ObstacleModel) {
        let remainingDuration = max(0, obstacle.soundDelay)
        
        soundManager.playPositionalSound(
            forLine: obstacle.line,
            playerLine: player.currentLine,
            soundIndex: obstacle.soundIndex,
            duration: remainingDuration
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + obstacle.soundDelay) { [weak self] in
            guard let self = self else { return }
            let creationTime = self.gameDuration - self.gameTimeRemaining
            
            var newObstacle = obstacle
            newObstacle.yPosition = UIScreen.main.bounds.height - 100
            newObstacle.spawnTime = creationTime
            self.obstacles.append(newObstacle)
        }
    }
    
    func updateGame() {
        guard !gameOver else { return }
        let currentTime = gameDuration - gameTimeRemaining

        obstacles.removeAll { obstacle in
            let obstacleAge = currentTime - obstacle.spawnTime
            return obstacleAge >= obstacle.duration
        }

        for index in obstacles.indices {
            if obstacles[index].isMoving {
                obstacles[index].yPosition += currentSpeed
            }
        }
        checkCollisions()
    }
    
    
    func checkCollisions() {
        for obstacle in obstacles {
            if !obstacle.isMoving && obstacle.line == player.currentLine {
                playCollisionAndStopGame(obstacle: obstacle)
                return
            }
            
            if obstacle.isMoving &&
               obstacle.line == player.currentLine &&
               abs(obstacle.yPosition - (UIScreen.main.bounds.height - 15)) < 15 {
                playCollisionAndStopGame(obstacle: obstacle)
                return
            }
        }
    }


    private func playCollisionAndStopGame(obstacle: ObstacleModel) {
        guard !gameOver else { return }

        stopGame()

        print("Playing collision sound: \(obstacle.collisionSound) for duration: \(obstacle.collisionSoundDuration)")
        soundManager.playCollisionSound(named: obstacle.collisionSound, duration: obstacle.collisionSoundDuration)

        DispatchQueue.main.asyncAfter(deadline: .now() + obstacle.collisionSoundDuration) {
            self.gameOver = true
            print("Game fully stopped after collision sound duration: \(obstacle.collisionSoundDuration) seconds")
            self.soundManager.stopCurrentSound()
        }
    }


    
    
    // MARK: - Player Movement

    func moveLeft() {
        guard !gameOver, player.currentLine > minLineIndex else { return }
        player.currentLine -= 1
        playSoundForActiveObstacle()
    }
    
    func moveRight() {
        guard !gameOver, player.currentLine < maxLineIndex else { return }
        player.currentLine += 1
        playSoundForActiveObstacle()
    }
    
    private func playSoundForActiveObstacle() {
        let remainingTime = gameDuration - gameTimeRemaining
        if let activeObstacle = obstacleSpawnData.first(where: { obstacle in
            obstacle.spawnTime - obstacle.soundDelay <= remainingTime && obstacle.spawnTime >= remainingTime
        }) {
            let remainingDuration = max(0, activeObstacle.spawnTime - remainingTime)
            soundManager.playPositionalSound(
                forLine: activeObstacle.line,
                playerLine: player.currentLine,
                soundIndex: activeObstacle.soundIndex,
                duration: remainingDuration
            )
        }
    }
    
    func xOffset(for line: Int, width: CGFloat) -> CGFloat {
        let lineSpacing: CGFloat = 135
        let offset = CGFloat(line - 1) * lineSpacing
        return offset
    }
}
