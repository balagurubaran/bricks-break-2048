//
//  Playing.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Michael Briscoe on 1/16/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
  unowned let scene: GameScene
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
    
    var xVelocity: CGFloat = 0
  
  override func didEnter(from previousState: GKState?) {
    if previousState is WaitingForTap {
        if(scene.childNode(withName: BallCategoryName)?.isHidden == false){
            let ball = scene.childNode(withName: BallCategoryName) as! SKSpriteNode
                ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(min: 0, max: 6), dy: abs(randomDirection(min: 7, max: 10))))
        }
        
    }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    if(scene.childNode(withName: BallCategoryName)?.isHidden == false){
        if let ball = scene.childNode(withName: BallCategoryName) as? SKSpriteNode {
            ballForce(ball: ball)
        }
    }
    
    for node in scene.children {
        if let usedata = node.userData, let _node = node as? SKSpriteNode {
            if usedata.object(forKey: "multiple") != nil || usedata.object(forKey: "islaser") != nil{
                ballForce(ball:_node)
            }
        }
    }
  }
    
    func ballForce(ball:SKSpriteNode){
        
        guard let physicsBody = ball.physicsBody else{
            return
        }
        let maxSpeed: CGFloat = 1000.0
        
        let xSpeed = sqrt(physicsBody.velocity.dx * physicsBody.velocity.dx)
        let ySpeed = sqrt(physicsBody.velocity.dy * physicsBody.velocity.dy)
        
        let speed = sqrt(physicsBody.velocity.dx * physicsBody.velocity.dx + physicsBody.velocity.dy * physicsBody.velocity.dy)
        
        if let usedata = ball.userData {
            if  usedata.object(forKey: "islaser") != nil{
                if ySpeed <= 10.0{
                    ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3.0))
                }
            }
        }else{
            if xSpeed <= 10.0 {
                physicsBody.applyImpulse(CGVector(dx: randomDirection(min: 5, max: 10), dy: 0.0))
            }
            if ySpeed <= 10.0 {
                physicsBody.applyImpulse(CGVector(dx: 0.0, dy: randomDirection(min: 7, max: 15)))
            }
        }
        if (speed < maxSpeed/2){
            physicsBody.velocity = CGVector.init(dx: physicsBody.velocity.dx * 2, dy: physicsBody.velocity.dy * 2)
        }
        
        if speed > maxSpeed {
            physicsBody.linearDamping = 0.4
        }
        else {
            physicsBody.linearDamping = 0.0
        }
        
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameOver.Type
  }
  
    func randomDirection(min:CGFloat, max:CGFloat) -> CGFloat {
    let speedFactor: CGFloat = scene.randomFloat(from: min, to: max)
    if scene.randomFloat(from: 0.0, to: 100.0) >= 50 {
      return -speedFactor
    } else {
      return speedFactor
    }
  }

  
}
