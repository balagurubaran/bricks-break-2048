//
//  MenuScene.swift
//  bricks break 2048
//
//  Created by Balagurubaran Kalingarayan on 4/2/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit


var actionIN = SKAction()
var actionStay = SKAction()
var actionOut = SKAction()

struct  defaultImageSize {
        static var playButtonSize = CGSize(width: 150, height: 150)
        static var ballSize       = CGSize(width: 100, height: 100)
}

extension SKSpriteNode {
    func resize(defaultSize:CGSize){
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        if  height >= 736 {
            self.size.height = self.size.height * 1.1
            self.size.width =  self.size.width * 1.1
            print(self.size.width)
        }else{
            self.size = defaultSize
        }
    }
}

class MenuScene: SKScene{
    
    var soundNode:SKSpriteNode = SKSpriteNode()
    
    
    var DoneMsg = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        actionIN = SKAction.moveTo(y: CGFloat.init(self.size.height - 100), duration: 1)
        actionStay = SKAction.moveTo(y: CGFloat.init(self.size.height - 100), duration: 1)
        actionOut = SKAction.moveTo(y: CGFloat.init(self.size.height + 200), duration: 2)
        
        DoneMsg = childNode(withName: "done") as! SKSpriteNode
        
        Utility.sharedInstance.isSound = (Utility.sharedInstance.userDefault?.bool(forKey: "music"))!
        soundNode = self.childNode(withName: "sound") as! SKSpriteNode
        soundNode.texture = SKTexture.init(imageNamed: "soundoff")
        if(Utility.sharedInstance.isSound){
            soundNode.texture = SKTexture.init(imageNamed: "soundon")
        }

        super.didMove(to: view)
        
        if let playButton = self.childNode(withName: "play") as? SKSpriteNode {
            playButton.resize(defaultSize: defaultImageSize.playButtonSize)
            soundNode.resize(defaultSize: defaultImageSize.ballSize)
        }
        
        if let resetButton = self.childNode(withName: "reset") as? SKSpriteNode {
            resetButton.resize(defaultSize: defaultImageSize.ballSize)
        }
        
        if let gameCenterButton = self.childNode(withName: "gamecenter") as? SKSpriteNode {
            gameCenterButton.resize(defaultSize: defaultImageSize.ballSize)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAdd"), object: nil)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNode = self.atPoint(pos)
        if(touchedNode.name == "play"){
            if(!Utility.sharedInstance.isHelpLoaded){
                Utility.sharedInstance.isHelpLoaded = true
                if let helpScene = HelpScene(fileNamed:"HelpScene") {
                    helpScene.scaleMode = .fill
                    let reveal = SKTransition.flipHorizontal(withDuration: 1)
                    self.view?.presentScene(helpScene, transition: reveal)
                }
            }else{
                if let gameScene = GameScene(fileNamed:"GameScene") {
                    gameScene.scaleMode = .fill
                    let reveal = SKTransition.flipHorizontal(withDuration: 1)
                    self.view?.presentScene(gameScene, transition: reveal)
                }
            }
        }else if(touchedNode.name == "gamecenter"){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showGameLeaderboard"), object: nil)
        }
        else if(touchedNode.name == "reset"){
            let alert = UIAlertController(title: "Reset", message: "Do you want reset the level", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                level = 1
                Totalscore = 0
                Utility.sharedInstance.userDefault?.set(level, forKey: "level")
                Utility.sharedInstance.userDefault?.set(Totalscore, forKey: "totalscore")
                Utility.sharedInstance.userDefault?.set(false, forKey: "newLevel")
                Utility.sharedInstance.userDefault?.synchronize()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            guard let viewController = view?.window?.rootViewController as? GameViewController else {
                return
            }
            viewController.present(alert, animated: true)
        }
        else if(touchedNode.name == "sound"){
            Utility.sharedInstance.isSound = !Utility.sharedInstance.isSound
            
            soundNode.texture = SKTexture.init(imageNamed: "soundoff")
            Utility.sharedInstance.userDefault?.set(Utility.sharedInstance.isSound, forKey: "music")
            
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
