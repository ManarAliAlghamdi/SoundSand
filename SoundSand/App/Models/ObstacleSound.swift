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
    
    init(obstacleSoundName: String, laneNo: Int, soundStatus: Bool) {
        self.obstacleSoundName = obstacleSoundName
        self.laneNo = laneNo
    }
}
