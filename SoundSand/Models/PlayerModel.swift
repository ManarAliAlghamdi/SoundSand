import Foundation

struct PlayerModel {
    var currentLine: Int = 1
}

struct ObstacleModel: Identifiable {
    let id = UUID()
    var line: Int
    var yPosition: CGFloat
    let creationTime: TimeInterval
    let duration: TimeInterval
}

struct ObstacleSpawnData {
    let line: Int
    let spawnTime: TimeInterval
    let soundFileName: String
    let soundDelay: TimeInterval
    let duration: TimeInterval     
}
