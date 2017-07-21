//
//  GameViewController.swift
//  Jetpack Dodge
//
//  Created by Pines on 7/13/17.
//  Copyright © 2017 Pines. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var rock1: UIImageView!
    @IBOutlet weak var rock2: UIImageView!
    @IBOutlet weak var coin1: UIImageView!
    @IBOutlet weak var pressAnywhereLabel: UILabel!
    @IBOutlet weak var dodgeTitle: UIImageView!
    @IBOutlet weak var spaceship: UIImageView!
    
    
    var audioPlayer = AVAudioPlayer()
    
    var screen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        
        }
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = 1000
        }
        catch {
            print(error)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func gameStart(_ sender: Any) {
    print(screen)
    background.isHidden = true
    background.layer.zPosition = -20
    button.isHidden = true
    coin1.isHidden = true
    rock1.isHidden = true
    rock2.isHidden = true
    spaceship.isHidden = true
    dodgeTitle.isHidden = true
    pressAnywhereLabel.isHidden = true
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    
}
