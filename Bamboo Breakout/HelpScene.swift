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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newScene = GameScene(fileNamed:"GameScene")
        newScene?.scaleMode = .fill
        let reveal = SKTransition.flipHorizontal(withDuration: 1)
        self.view?.presentScene(newScene!, transition: reveal)
    }
}
