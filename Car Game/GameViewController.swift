//
//  GameViewController.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hightScoreLabel: UILabel!
    @IBOutlet weak var loadImageView: UIImageView!

    var scene = GameScene(fileNamed:"GameScene")
    var gasButtonState = false
    var brakeButtonState = false
    let textureAtlas = SKTextureAtlas(named: "texture.atlas")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageView.isHidden = false
        SwiftSpinner.show("Loading...", animated: true)
        
        scene?.gameViewControllerBridge = self
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        //skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene!.scaleMode = .aspectFill
        
       // textureAtlas.preload(completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                SwiftSpinner.hide()
                self.loadImageView.isHidden = true
                skView.presentScene(self.scene)
            })
       // })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
