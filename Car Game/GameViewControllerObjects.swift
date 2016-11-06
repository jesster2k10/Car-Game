//
//  GameController_Touches.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import Foundation
import SpriteKit

extension GameViewController {
    
    @IBAction func gasButton(_ sender: UIButton){
        gasButtonState = true
    }
    
    @IBAction func brakeButton(_ sender: UIButton){
        brakeButtonState = true
    }
    
    @IBAction func gasButtonUp(_ sender: UIButton) {
        gasButtonState = false
    }
    @IBAction func brakeButtonUp(_ sender: UIButton) {
        brakeButtonState = false
    }
    
    @IBAction func reloadButton(_ sender: UIButton) {
        scene?.reloadGame()
    }
    
    @IBAction func camScale(_ sender: UIButton) {
        scene?.cam.xScale += 5
        scene?.cam.yScale += 5
        print("cam scale + 5")
    }
    
    @IBAction func returnToMenuButton(sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigationController?.view.layer.add(transition, forKey: nil)

        _ = navigationController?.popViewController(animated: false)
        navigationController?.dismiss(animated: false, completion: nil)
        
        DispatchQueue.main.async {
            self.scene?.removeAll()
        }
    }
}
