//
//  GameScene.swift
//  Jetpack Dodge
//
//  Created by Pines on 7/13/17.
//  Copyright © 2017 Pines. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

struct ColliderType {
    static let Player: UInt32 = 1
    static let Enemy: UInt32 = 2
    static let Coin: UInt32 = 3
}


let spaceShipTexture = SKTexture(image: #imageLiteral(resourceName: "ship6"))
let coinTexture = SKTexture(image: #imageLiteral(resourceName: "coin1"))
let enemyTexture = SKTexture(image: #imageLiteral(resourceName: "rock1"))
var timer1 = SKAction.wait(forDuration: 4)







class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(texture: spaceShipTexture)
    var textureArray = [SKTexture]()
    
    var coin = SKSpriteNode(texture: coinTexture)
    var coinTextureArray = [SKTexture]()
    
    var enemy = SKSpriteNode(texture: enemyTexture)
    var rockTextureArray = [SKTexture]()
    
    var scoreboard = SKSpriteNode(color: SKColor.green, size: CGSize(width: 750, height:40))
    var label = SKLabelNode()
    
    var lives = 2
    var score = 0

    var invincible: Int = 0
    var coinInvincible: Int = 0
    var timer: Timer?
    var timer2: Timer?
    
    var losingDisplay = SKSpriteNode(color: SKColor.red, size: CGSize(width: 500, height: 300))
    var losingLabel = SKLabelNode()
    
    func reduce() {
        if invincible > 0 {
            invincible -= 1
            print("timer running, \(invincible) seconds of invincibility remain")
        } else {
            print("timer running, no invincibility")
        }
        
    }
    
    func reduce2() {
        if coinInvincible > 0 {
            coinInvincible -= 1
            print("Coin Invincible running, \(coinInvincible) seconds of Coin Invincibility remain")
        } else {
            print("Coin Invincible not running")
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reduce), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reduce2), userInfo: nil, repeats: true)

        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.contactDelegate = self
        
        player.name = "Player"
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.size = CGSize(width: 400, height: 500)
        player.position = CGPoint(x: 0, y: -500)
        player.physicsBody = SKPhysicsBody(texture: spaceShipTexture, size: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.Enemy
        player.physicsBody?.contactTestBitMask = ColliderType.Enemy
        
        self.addChild(player)
        
        enemy.name = "Enemy"
        enemy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        enemy.size = CGSize(width: 500, height: 600)
        enemy.color = UIColor.red
        enemy.position = CGPoint(x: -300, y: 800)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody = SKPhysicsBody(texture: enemyTexture, size: enemy.size)
        enemy.physicsBody?.categoryBitMask = ColliderType.Enemy
        
        self.addChild(enemy)
        
        coin.name = "Coin"
        coin.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        coin.size = CGSize(width: 300, height: 300)
        coin.position = CGPoint(x: 300, y: 800)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = true
        coin.physicsBody = SKPhysicsBody(texture: coinTexture, size: coin.size)
        coin.physicsBody?.categoryBitMask = ColliderType.Coin
        
        self.addChild(coin)

        
        
        player.isHidden = false
        
        
        self.scoreboard.position = CGPoint(x: 0, y: -650)
        self.scoreboard.color = UIColor(red: 150, green: 0, blue: 0, alpha: 0.3)
                self.addChild(scoreboard)
        
        self.losingDisplay.position = CGPoint(x: 0, y: 0)
        self.addChild(losingDisplay)
        losingDisplay.isHidden = true
        
        for i in (1...6)
        {
            let textureName = "ship\(i)"
            textureArray.append(SKTexture(imageNamed: textureName))
        }
        
        for i in (1...4)
        {
            let coinTextureName = "coin\(i)"
            coinTextureArray.append(SKTexture(imageNamed: coinTextureName))
        }
        
        for i in (1...4){
            let rockTextureName = "rock\(i)"
            rockTextureArray.append(SKTexture(imageNamed: rockTextureName))
        }
        
        
        player.run(SKAction.repeatForever(
            SKAction.animate(with: textureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Ship")
        
        coin.run(SKAction.repeatForever(
            SKAction.animate(with: coinTextureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Coin")
        
        enemy.run(SKAction.repeatForever(
            SKAction.animate(with: rockTextureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Rock")
        
    
        self.addChild(label)
        self.addChild(losingLabel)
        
        
        generateEnemies()

    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            if(lives > 0)
            {
            player.run(SKAction.moveTo(x: location.x, duration: 0.25)) // moves ship to x location of touch
            player.run(SKAction.moveTo(y: location.y, duration: 0.25)) // moves ship to y location of touch
            }
            
            
            
            
            
            
        }
        
         generateEnemies()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        enemy.isHidden = false
        
        for touch in touches {
            if(lives > 0)
            {
            let location = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: location.x, duration: 0.25)) // moves ship to x location of touch
            
            player.run(SKAction.moveTo(y: location.y, duration: 0.25)) // moves ship to y location of touch
            }
            
            
            
            
            
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // called before each frame is rendered
//        self.label.text = "   lives:      \(lives)                               score:     \(score)"
        self.label.fontName = "Times New Roman"
        self.label.position = CGPoint(x : -60, y: -660)
        self.label.text = "   lives:      \(lives)                               score:     \(score)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
    
    var firstBody = SKPhysicsBody()
    
    var secondBody = SKPhysicsBody()
    
    if contact.bodyA.node?.name == "Player" {
    firstBody = contact.bodyA
    secondBody = contact.bodyB
    
    } else {
    firstBody = contact.bodyB
    secondBody = contact.bodyA
    }
    
    
    if firstBody.node?.name == "Player" && secondBody.node?.name == "Enemy" {
    print("Contact Detected")
    self.enemy.isHidden = true
    self.enemy.removeAllActions()
    
       
                if invincible == 0 {
            lives -= 1
            invincible = 1
        } else {
            
        }
        
        

        if(lives == 0)
        {
            losingDisplay.isHidden = false
            
            self.losingLabel.fontName = "Times New Roman"
            self.losingLabel.fontSize = 24
            self.losingLabel.position = CGPoint(x : 0, y: 0)
            self.losingLabel.color = UIColor.blue
            self.losingLabel.text = "Game Over \n Your Score:  \(score)"
        }
}
    
    
    if firstBody.node?.name == "Player" && secondBody.node?.name == "Coin" {
           self.coin.position.y -= 800
    self.coin.isHidden = true
    self.coin.removeAllActions()
        if coinInvincible == 0 {
            score += 1
            coinInvincible = 1
        } else {
            
        }

    }
        
    

    }


    
    func generateEnemies(){
        
        if(self.action(forKey: "spawning") != nil){return}
        
        
        
        timer1 = SKAction.wait(forDuration: 2)
        
        
        
        
        let spawnNode = SKAction.run {
            
            if(self.lives > 0) {
            let randomXStart = arc4random_uniform(5)
            var startPoint = CGPoint(x: 0, y: 0)
            
            if randomXStart == 0 {
                startPoint = CGPoint(x: -250, y: 800)
            } else if randomXStart == 1 {
                startPoint = CGPoint(x: 0, y: 800)
            } else if randomXStart == 2 {
                startPoint = CGPoint(x: 250, y: 800)
            } else if randomXStart == 3 {
                startPoint = CGPoint(x: -150, y: 800)
            } else if randomXStart == 4 {
                startPoint = CGPoint(x: 150, y: 800)
            }
            
            //spawn enemies inside view's bounds
            let spawnLocation = startPoint
            
            self.enemy.position = spawnLocation
            self.enemy.physicsBody?.velocity = CGVector(dx: 0, dy: -20)
            self.enemy.isHidden = false
            self.enemy.run(SKAction.repeatForever(
                SKAction.animate(with: self.rockTextureArray,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),withKey:"Rock")
            
            
            
            let randomize = Int(arc4random_uniform(500)) - 250
            self.coin.position = CGPoint(x: randomize, y: 800)
            self.coin.physicsBody?.velocity = CGVector(dx: 0, dy: -20)
            self.coin.isHidden = false
            self.coin.hasActions()
            
            self.coin.run(SKAction.repeatForever(
                SKAction.animate(with: self.coinTextureArray,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),withKey:"Coin")
            

        }
        }
        
        let sequence = SKAction.sequence([timer1, spawnNode])
        
        
        self.run(SKAction.repeatForever(sequence) , withKey: "spawning") // run action with key so you can remove it later
    }

    
}

