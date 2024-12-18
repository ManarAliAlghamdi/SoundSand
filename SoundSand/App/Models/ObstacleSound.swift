//
//  eventSound.swift
//  SoundSand
//
//  Created by Manar Alghmadi on 15/12/2024.
//

import Foundation

// Represents the sounds associated with an obstacle in the game.
class ObstacleSound {
    var obstacleSoundName: String
    var laneNo: Int
    var soundStatus: Bool
    
    init(obstacleSoundName: String, laneNo: Int, soundStatus: Bool) {
        self.obstacleSoundName = obstacleSoundName
        self.laneNo = laneNo
        self.soundStatus = soundStatus
    }
}
