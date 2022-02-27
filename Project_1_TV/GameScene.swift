//
//  GameScene.swift
//  Project1
//
//  Created by Ritchie Andrews on 2/26/22.
//

import SpriteKit
import GameplayKit

@objcMembers

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Player is created here so it can be used throughout the game
    
    let player = SKSpriteNode(imageNamed: "player-rocket.png")
    var touchingPlayer = false
    
    var gameTimer: Timer?
    
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    let music = SKAudioNode(fileNamed: "overworld.mp3")
    
    
    
    
    override func didMove(to view: SKView) {
        
        // This method is called when your game scene is ready to run
        
        
        // starts timer for enemy creation
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        
        // We modify the snow particles to create space dust and move time ahead to fill screen at game start
        
        if let particles = SKEmitterNode(fileNamed: "SpaceDust") {
            particles.advanceSimulationTime(20)
            particles.position.x = 960
            addChild(particles)
        }
        
        // This displays the player and sets its position to the left side of the screen
        
        player.position.x = -850
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = 1
        addChild(player)
        
        physicsWorld.contactDelegate = self
        
        // Score tracking
        
        scoreLabel.zPosition = 2
        scoreLabel.position.y = 500
        addChild(scoreLabel)
        
        score = 0
        addChild(music)
     
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // this method is called when the user touches the screen
        // check to see if location contains the player if it does make touchingPlayer true
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(player) {
            touchingPlayer = true
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // if player is being touched move to new location
        
        guard touchingPlayer else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        player.position = location
        
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // this method is called when the user stops touching the screen and sets touchingPlayer to false
        
        touchingPlayer = false
    }

    override func update(_ currentTime: TimeInterval) {
        
        // this method is called before each frame is rendered
        
        for node in children {
            if node.position.x < -1100 {
                node.removeFromParent()
            }
        }
        
        if player.position.x < -900 {
            player.position.x = -900
        } else if player.position.x > 900 {
            player.position.x = 900
        }
        
        if player.position.y < -500 {
            player.position.y = -500
        } else if player.position.y > 500 {
            player.position.y = 500
        }
    }
    
   
   
    
    func createEnemy() {
            
            // Code goes here
        createBonus()
        
       
        let randomDistribution = GKRandomDistribution(lowestValue: -500, highestValue: 500)
        let sprite = SKSpriteNode(imageNamed: "asteroid")
        
        
            
            sprite.position = CGPoint(x: 1100, y: randomDistribution.nextInt())
            sprite.name = "enemy"
            sprite.zPosition = 1
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.linearDamping = 0.0
            sprite.physicsBody?.contactTestBitMask = 1
            sprite.physicsBody?.categoryBitMask = 0
        
        }
    
    func createBonus() {
            
            // Code goes here
        
      
        
        let randomDistribution = GKRandomDistribution(lowestValue: -500, highestValue: 500)
        let sprite = SKSpriteNode(imageNamed: "energy")
        
        
            
            sprite.position = CGPoint(x: 1100, y: randomDistribution.nextInt())
            sprite.name = "bonus"
            sprite.zPosition = 1
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.linearDamping = 0.0
            sprite.physicsBody?.contactTestBitMask = 1
            sprite.physicsBody?.categoryBitMask = 0
            sprite.physicsBody?.collisionBitMask = 0
            
        
        }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    func playerHit(_ node: SKNode) {
        if node.name == "bonus" {
            score += 1
            node.removeFromParent()
            let sound = SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false)
            run (sound)
            
            return
        }
        if let particles = SKEmitterNode(fileNamed: "Explosion.sks") {
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
            
        }
        player.removeFromParent()
        music.removeFromParent()
        let gameOver = SKSpriteNode(imageNamed: "gameOver-2")
        gameOver.zPosition = 10
        addChild(gameOver)
        // wait for two seconds then run some code
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            // create a new scene from GameScene.sks
            
            if let scene = GameScene(fileNamed: "GameScene"){
                // make it strech to fill all available space
                scene.scaleMode = .aspectFill
                
                // present it immediately
                self.view?.presentScene(scene)
                
            }
        }
        
                let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
                run (sound)
                
        
    }
    
    }

