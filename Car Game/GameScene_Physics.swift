//
//  GameScene_Physics.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //UserDefaults.standard.set(highScore, forKey: "highScore")
        Model.sharedInstance.setHighScore()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == carGroup {
            if secondBody.node?.parent != nil {
                secondBody.node?.removeFromParent()
            }
        }
        //else if firstBody.categoryBitMask == coinGroup && secondBody.categoryBitMask == carGroup {
        //    print("nope")
        //}
    }
}
