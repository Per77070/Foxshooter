//
//  GameScene.swift
//  Foxshooter
//
//  Created by Per Gustafsson on 2019-01-11.
//  Copyright © 2019 Per Gustafsson. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
   let shotSound1 = SKAction.playSoundFileNamed("111047__cyberkineticfilms__gunshot-2-laser.wav", waitForCompletion: false)
  let explosionSound = SKAction.playSoundFileNamed("362423__alphatrooper18__explosion1.wav", waitForCompletion: false)
    
    
    var fox = SKSpriteNode()
    
     var foxRun :SKAction?
    var gameTimer: Timer?
   
    let scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    let balloonCategory:UInt32 = 0x1 << 1
    let ballCategory:UInt32 = 0x1 << 0
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        // Create shape node to use during mouse interaction
        if let node = self.childNode(withName: "fox") as? SKSpriteNode{
            fox = node
            
            var startClouds = 1
            repeat{
                moveClouds()
                moveBalloons()
                moveObjects()
                startClouds -= 1
            } while (startClouds >= 1)
            
            }
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: -self.frame.size.width/2+30, y: (self.frame.size.height/2)-10*(scoreLabel.fontSize+30))
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        
        
        
        foxRun = SKAction(named: "foxRun")
        fox.removeAllActions()
        
        self.physicsWorld.contactDelegate = self
    }
    
    func randomNmb(nmbMin: Int, nmbMax: Int) -> Int{
        let number = Int.random(in: nmbMin ... nmbMax)
        return number
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let nodeLocation = fox.position
            print(nodeLocation)
            let touchPoint = touch.location(in: view)
            let touchLocation = convertPoint(fromView: touchPoint)
            
            if let foxAction = foxRun {
                fox.run(foxAction)
            }
            
            let a = touchLocation.x - nodeLocation.x
            
            if a > 0 {
                fox.xScale = -0.5
            } else {
                fox.xScale = 0.5
            }
            
            let moveAction = SKAction.moveBy(x: a, y: 0, duration: 0.5)
            fox.run(moveAction)
            
            fox.run(moveAction, completion: {() -> Void in
                self.fox.removeAllActions()
                self.fox.texture = SKTexture(imageNamed: "fox.png")
            
            
            })
        }
    }
        
    @objc func moveClouds(){
        
        // Skapa moln-array
        let cloudImg = ["cloudA", "cloudB"]
        
        // slumpa moln bild och placera startpunkt
        let getRndCloud = randomNmb(nmbMin: 0, nmbMax: 1)
        let cloud = SKSpriteNode(imageNamed: cloudImg[getRndCloud])
        cloud.position.x = -((cloud.size.width)*2)
        
        // Slumpa höjd samt skapa en maxhöjd på 180.
        cloud.position.y = CGFloat(randomNmb(nmbMin: 0, nmbMax: 180))
        cloud.zPosition = 1
        
        // Slumpa hastighet
        let duration = randomNmb(nmbMin: 20, nmbMax: 50)
        
        // Slumpa xScale på moln
        if randomNmb(nmbMin: 0, nmbMax: 1) > 0 {
            cloud.xScale = -1
        } else {
            cloud.xScale = 1
        }
        
        // Slumpad höjdstorlek och opacitet
        cloud.yScale = CGFloat(randomNmb(nmbMin: 1, nmbMax: 3))
        cloud.alpha = CGFloat(Float(randomNmb(nmbMin: 1, nmbMax: 2))/10)
        
        self.addChild(cloud)
        
        //Kör molnen
        let moveCloud = SKAction.moveTo(x: self.size.width + cloud.size.width, duration: TimeInterval(duration))
        let deleteCloud = SKAction.removeFromParent()
        let cloudSequence = SKAction.sequence([ moveCloud, deleteCloud])
        cloud.run(cloudSequence)
        
    }

    @objc func moveBalloons(){
        
        // array av ballonger i olika färger
        let balloonArray = ["balloon1", "balloon2", "balloon3", "balloon4", "balloon5"]
        
        // slumpa ballong och placera startpunkt
        let getRndBalloon = randomNmb(nmbMin: 0, nmbMax: 4)
        let balloon = SKSpriteNode(imageNamed: balloonArray[getRndBalloon])
        balloon.position.x = -((balloon.size.width))
        
        // slumpa höjd minst mittpunkt till 180 upp
        balloon.position.y = CGFloat(randomNmb(nmbMin: 0, nmbMax: 180))
        balloon.zPosition = 1
        
        // slumpa hastighet
        let duration = randomNmb(nmbMin: 2, nmbMax: 15)
        
        // Slumpa xScale på moln
        if randomNmb(nmbMin: 0, nmbMax: 2) > 0 {
            balloon.xScale = -1
        } else {
            balloon.xScale = 1
        }
        
        // Slumpad höjdstorlek och opacitet
        balloon.yScale = CGFloat(randomNmb(nmbMin: 1, nmbMax: 2))
        balloon.alpha = CGFloat(Float(randomNmb(nmbMin: 3, nmbMax: 7))/10)
        
        self.addChild(balloon)
        
        //Kör ballongerna
        let moveBalloon = SKAction.moveTo(x: self.size.width + balloon.size.width, duration: TimeInterval(duration))
        let deleteBalloon = SKAction.removeFromParent()
        let balloonSequence = SKAction.sequence([ moveBalloon, deleteBalloon])
        
        
        balloon.physicsBody = SKPhysicsBody(rectangleOf: balloon.size)
        balloon.physicsBody?.isDynamic = true
        balloon.physicsBody?.affectedByGravity = false
        balloon.physicsBody?.categoryBitMask = balloonCategory
        balloon.physicsBody?.contactTestBitMask = ballCategory
        balloon.physicsBody?.collisionBitMask = 0
        balloon.physicsBody?.usesPreciseCollisionDetection = true
 
 //self.addChild(balloon)
 
        balloon.run(balloonSequence)
    }
    
    
    func moveObjects(){
        let rndCloudTimer = randomNmb(nmbMin: 1, nmbMax: 2)
        
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(rndCloudTimer), target: self, selector: #selector(moveClouds), userInfo: nil, repeats: true)
        
        let rndBalloonTimer = randomNmb(nmbMin: 1, nmbMax: 2)
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(rndBalloonTimer), target: self, selector: #selector(moveBalloons), userInfo: nil, repeats: true)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ball = SKSpriteNode(imageNamed: "ball.red")
        ball.position.x = fox.position.x
        ball.position.y = fox.position.y + (fox.size.height / 2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/10)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = balloonCategory
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(ball)
        let moveBall = SKAction.moveTo(y: self.size.height + ball.size.height, duration: 5)
        let deleteBall = SKAction.removeFromParent()
        let moveFoxAndSound = SKAction.group([shotSound1, moveBall])
        let ballSequence = SKAction.sequence([ moveFoxAndSound, deleteBall])
    
        ball.run(ballSequence)
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1: SKPhysicsBody
        var body2: SKPhysicsBody
        
        
        
        if contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask
        {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.contactTestBitMask != 0 {
            
            if body1.node != nil {
                explosion(spritePosition: body1.node!.position)
                
                score += 1
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func explosion(spritePosition: CGPoint)
    {
        let explosion = SKSpriteNode(imageNamed: "balloon_explode")
        explosion.position = spritePosition
        explosion.zPosition = 50
        self.addChild(explosion)
        
        let scale = SKAction.scale(to: 1.8, duration: 0.2)
        let delete = SKAction.removeFromParent()
        let explosionGroup = SKAction.group([scale, explosionSound])
        let explosionSeq = SKAction.sequence([explosionGroup, delete])
        explosion.run(explosionSeq)
        
    }
}

