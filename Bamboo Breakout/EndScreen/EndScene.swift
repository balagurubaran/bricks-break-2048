import SpriteKit

class EndScene: SKScene {
    
    let reveal = SKTransition.push(with: .right, duration: 0.33)
    override func didMove(to view: SKView) {
        for each in self.scene?.children ?? []{
            each.zPosition = 1
        }
        print(self.scene?.children.count)
    }
    
    //
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        for touch in touches {
            
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        var newScene = SKScene()
        let touchedNode = self.atPoint(pos)
        if(touchedNode.name == "menu"){
            newScene = MenuScene(fileNamed:"MenuScene")!
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene, transition: reveal)
        } else {
            retry()
        }
    }
    
    func retry() {
        let newScene = GameScene(fileNamed:"GameScene")!
        newScene.scaleMode = .fill
        self.view?.presentScene(newScene, transition: reveal)
    }
}
