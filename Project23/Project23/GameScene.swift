//
//  GameScene.swift
//  Project23
//
//  Created by Jeffrey Eng on 9/2/16.
//  Copyright (c) 2016 Jeffrey Eng. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    
    // player image
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    // score property with property observer
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: NSTimer!
    var gameOver = false
    
    override func didMoveToView(view: SKView) {
        // set background to black since this is space
        backgroundColor = UIColor.blackColor()
        
        // create starfield
        starfield = SKEmitterNode(fileNamed: "Starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        // create player node
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        // score label node
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .Left
        addChild(scoreLabel)
        
        // initialize score to 0 upon launching of app and loading view
        score = 0
        
        // define physics world gravity to none
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //create scheduled timer
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        // check all nodes to see if they've crossed the -300 x-position and remove
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        // keep incrementing the score if gameOver is still false (code executes when the if statement evaluates to true, so as long as gameOver property is still false, score will continue incrementing)
        if !gameOver {
            score += 1
        }
    }
    
    func createEnemy() {
        // Use GameplayKit to randomize enemies array
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
        // Create random number for the y-position of the enemy sprite node
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)
        
        // Create instance of enemy sprite node
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        // Position enemy sprite node with fixed x-position so it starts off screen and give random y-position within the range of 50-736
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        // Add the sprite node to the Game Scene
        addChild(sprite)
        
        // Define physics properties of the instantiated enemy sprite node and use per-pixel collision
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        // set linear and angular damping to 0 to simulate frictionless space environment
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
}
