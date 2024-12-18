import Foundation

struct PlayerModel {
    var currentLine: Int = 1
}

struct ObstacleModel: Identifiable {
    let id = UUID()
    var line: Int
    var yPosition: CGFloat
    var appearenceTime: TimeInterval
    let soundDelay: TimeInterval
    let duration: TimeInterval
    let soundIndex: Int
    var collisionSound: String
    var collisionSoundDuration: TimeInterval
    var played: Bool = false
    var isMoving: Bool = false
}
