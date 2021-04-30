//
//  HelpScene.swift
//  bricks break 2048
//
//  Created by Balagurubaran Kalingarayan on 4/14/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class HelpScene:SKScene {
    let reveal = SKTransition.push(with: .left, duration: 1)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newScene = GameScene(fileNamed:"GameScene")
        newScene?.scaleMode = .fill
        self.view?.presentScene(newScene!, transition: reveal)
    }
    
    override func didMove(to view: SKView) {
        if let playButton = self.childNode(withName: "helpText") as? SKSpriteNode {
            playButton.zPosition = 1
        }
    }
    
}
