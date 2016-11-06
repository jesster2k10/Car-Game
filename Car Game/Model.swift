//
//  Model.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import Foundation

class Model {
    
    static let sharedInstance = Model() //Singlton
    
    var score = 0
    var highScore = UserDefaults.standard.object(forKey: "highScore") as? Int ?? 0
    
    func setHighScore() {
        UserDefaults.standard.set(self.highScore, forKey: "highScore")
    }
}
