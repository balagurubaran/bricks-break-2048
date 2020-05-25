//
//  MenuScene.swift
//  bricks break 2048
//
//  Created by Balagurubaran Kalingarayan on 4/2/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

struct  defaultImageSize {
        static var playButtonSize = CGSize(width: 100, height: 100)
        static var ballSize       = CGSize(width: 50, height: 50)
}

class MenuScene: SKScene{
    
    var soundNode:SKSpriteNode = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        Utility.sharedInstance.isSound = (Utility.sharedInstance.userDefault.bool(forKey: "music"))
        if let _soundNode = self.childNode(withName: "sound") as? SKSpriteNode {
            soundNode = _soundNode
            soundNode.texture = SKTexture.init(imageNamed: "soundoff")
            if(Utility.sharedInstance.isSound){
                soundNode.texture = SKTexture.init(imageNamed: "soundon")
            }
        }
        super.didMove(to: view)
        
        if let playButton = self.childNode(withName: "play") as? SKSpriteNode {
            playButton.size = defaultImageSize.playButtonSize
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNode = self.atPoint(pos)
        if(touchedNode.name == "play"){
            let newScene = GameScene(fileNamed:"GameScene")
            newScene?.scaleMode = .fill
            let reveal = SKTransition.flipHorizontal(withDuration: 1)
            self.view?.presentScene(newScene!, transition: reveal)
        }else if(touchedNode.name == "gamecenter"){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showGameLeaderboard"), object: nil)
        }
        else if(touchedNode.name == "reset"){
            level = 1
             Utility.sharedInstance.userDefault.set(level, forKey: "level")
        }
        else if(touchedNode.name == "sound"){
            Utility.sharedInstance.isSound = !Utility.sharedInstance.isSound
            
            soundNode.texture = SKTexture.init(imageNamed: "soundoff")
            Utility.sharedInstance.userDefault.set(Utility.sharedInstance.isSound, forKey: "music")
            
            if(Utility.sharedInstance.isSound){
                soundNode.texture = SKTexture.init(imageNamed: "soundon")
            }
        }

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
