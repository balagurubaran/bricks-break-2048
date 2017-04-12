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
  
  override func didEnter(from previousState: GKState?) {
    if previousState is WaitingForTap {
      let ball = scene.childNode(withName: BallCategoryName) as! SKSpriteNode
        
        //let dx:CGFloat =  ball.position.x - touchPoint.x
        //ball.physicsBody!.velocity.dx = dx
    
        ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: abs(randomDirection())))
        

//        let deltaX = (ball.position.x - touchPoint.x) * 180/3.14
//        let deltaY = (ball.position.y - touchPoint.y) * 180/3.14
//        let angle = atan2f(Float(deltaX), Float(deltaY))
//        ball.zRotation = CGFloat(angle)
//        
//        print(cosf(Float(deltaX)),sinf(Float(deltaY)))
//        ball.physicsBody!.applyForce(CGVector.init(dx: cos(deltaX), dy: sin(deltaY)))
        
    }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    let ball = scene.childNode(withName: BallCategoryName) as! SKSpriteNode
    ballForce(ball: ball)
    
    for node in scene.children {
        if let usedata = node.userData {
            if let value = usedata.object(forKey: "multiple"){
                ballForce(ball: node as! SKSpriteNode)
            }
        }
    }
  }
    
    func ballForce(ball:SKSpriteNode){
        let maxSpeed: CGFloat = 1000.0
        
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        if xSpeed <= 1.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if ySpeed <= 1.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        }
        
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        }
        else {
            ball.physicsBody!.linearDamping = 0.0
        }
    }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameOver.Type
  }
  
  func randomDirection() -> CGFloat {
    let speedFactor: CGFloat = scene.randomFloat(from: 7.0, to: 10.0)
    if scene.randomFloat(from: 0.0, to: 100.0) >= 50 {
      return -speedFactor
    } else {
      return speedFactor
    }
  }

  
}
