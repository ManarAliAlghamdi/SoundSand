import Foundation

struct PlayerModel {
    var currentLine: Int = 1
}

//struct ObstacleModel: Identifiable {
//    let id = UUID()
//    var line: Int
//    var yPosition: CGFloat
//    let creationTime: TimeInterval
//    let duration: TimeInterval
//    var isMoving: Bool = false
//}

//struct ObstacleSpawnData {
//    let line: Int
//    let spawnTime: TimeInterval
//    let soundDelay: TimeInterval
//    let duration: TimeInterval
//    let soundIndex: Int
//    var played: Bool = false 
//}

struct ObstacleModel: Identifiable {
    let id = UUID()
    var line: Int
    var yPosition: CGFloat
    var spawnTime: TimeInterval
    let soundDelay: TimeInterval
    let duration: TimeInterval
    let soundIndex: Int
    var played: Bool = false
    var isMoving: Bool = false
}

