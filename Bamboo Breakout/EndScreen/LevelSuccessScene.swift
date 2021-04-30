//
//  EndScene.swift
//  GTVladimirVinnik
//
//  Created by Vladimir Vinnik on 27.08.16.
//  Copyright © 2016 Vladimir Vinnik. All rights reserved.
//

///////////////////////////////////////////////////////////////////
///                                                             ///
///   DOCUMENTATION HERE: https://twitter.com/VldrVnnkSupport   ///
///   also you can find here some news and other                ///
///                                                             ///
///   I AVAILABLE TO FREELANCE WORK                             ///
///                                                             ///
///////////////////////////////////////////////////////////////////

import SpriteKit

class LevelSuccessScene: SKScene {
    
    let reveal = SKTransition.push(with: .right, duration: 0.33)
    override func didMove(to view: SKView) {
        for each in self.scene?.children ?? []{
            each.zPosition = 1
        }
    }
    
    //
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        var newScene = SKScene()
        let touchedNode = self.atPoint(pos)
        if(touchedNode.name == "menu"){
            newScene = MenuScene(fileNamed:"MenuScene")!
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene, transition: reveal)
        } else if(touchedNode.name == "play"){
            let newScene = GameScene(fileNamed:"GameScene")!
            newScene.scaleMode = .fill
            self.view?.presentScene(newScene, transition: reveal)
        } 
    }
}
