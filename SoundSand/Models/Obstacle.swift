//
//  Events.swift
//  SoundSand
//
//  Created by Manar Alghmadi on 15/12/2024.
//

import Foundation



// Represents an obstacle in the game, including its stage, lane, and sounds
class Obstacles{
    var levelNo: Int
    var obstacleLane: Int
    var obstacleTimer: TimeInterval
    var obstcaleApperance: TimeInterval
    var obstacleSound: [ObstacleSound]
    
    
    init(levelNo: Int, obstacleLane: Int, obstacleTimer: TimeInterval,  obstcaleApperance: TimeInterval,obstacleSound: [ObstacleSound]) {
        self.levelNo = levelNo
        self.obstacleLane = obstacleLane
        self.obstacleTimer = obstacleTimer
        self.obstacleSound = obstacleSound
        self.obstcaleApperance = obstcaleApperance
    }
}

 
