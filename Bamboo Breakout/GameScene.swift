//
//  GameScene.swift
//  Bamboo Breakout
/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4


var scoreText = SKLabelNode()
var levelText = SKLabelNode()
var levelCOmpletedScreen = SKSpriteNode()
var levelFailed = SKSpriteNode()
var geniusScreen = SKSpriteNode()
var soundNode    = SKSpriteNode()

var score = 0
var level = 1
var Totalscore = 0
let numberOfBlocks = 83

var totalBallCount = 0
var gameCount = 0

var touchPoint = CGPoint()
let actionScale1 = SKAction.scale(to: 1.0, duration: 0.2)
let actionScale0 = SKAction.scale(to: 0.0, duration: 0)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    var gameWon : Bool = false {
        didSet {
            gameCount = gameCount + 1
            if(gameCount >= 8){
                gameCount = 0
                AdMob.shared.addInterstitial()
            }
            soundNode.isHidden = false
            soundNode.run(actionScale1)

            if(!gameWon){
                levelFailed.run(actionScale1)
            }else{
                levelCOmpletedScreen.run(actionScale1)
                levelCompletedText.text = "Level \(level - 1) Completed"
                levelpointText.text = "Level Score : \(score)"
                totalpointText.text = "Total Score : \(Totalscore)"
                
            }
            if Utility.sharedInstance.isSound{
                run(gameWon ? gameWonSound : gameOverSound)
            }
        }
    }
    
    let blipSound = SKAction.playSoundFileNamed("pongblip", waitForCompletion: false)
    let blipPaddleSound = SKAction.playSoundFileNamed("paddleBlip", waitForCompletion: false)
    let bambooBreakSound = SKAction.playSoundFileNamed("BambooBreak", waitForCompletion: false)
    let gameWonSound = SKAction.playSoundFileNamed("game-won", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("game-over", waitForCompletion: false)
    let jsonParser = JSONParser()
    
    //LevelCompletedNode
    
    var levelCompletedText = SKLabelNode()
    var levelpointText = SKLabelNode()
    var totalpointText = SKLabelNode()
    var paddle = SKSpriteNode()
    
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        geniusScreen = childNode(withName: "genius") as! SKSpriteNode
        
        if let currentlevel = Utility.sharedInstance.userDefault?.object(forKey: "level") {
            level = currentlevel as! Int
        }else {
            level = 1
        }
        levelText = childNode(withName: "level") as! SKLabelNode
        scoreText = childNode(withName: "score") as! SKLabelNode
        
        if((Utility.sharedInstance.userDefault?.bool(forKey: "newLevel"))! && Utility.sharedInstance.totalLevel == level){
            if(Utility.sharedInstance.totalLevel == level){
                levelpointText.isHidden = true
                geniusScreen.run(actionScale1)
                levelText.text = ""
                scoreText.text = ""
            }
        }else{
            
            if(Utility.sharedInstance.userDefault?.bool(forKey: "newLevel"))!{
                Utility.sharedInstance.userDefault?.set(false, forKey: "newLevel")
                level = level + 1
                Utility.sharedInstance.userDefault?.set(level, forKey: "level")
            }
            addPhysicsWorld()
            
            
            
            let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
            gameMessage.name = GameMessageName
            gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
            gameMessage.zPosition = 4
            gameMessage.setScale(0.0)
            addChild(gameMessage)
            
            levelCOmpletedScreen = childNode(withName: "levelcompleted") as! SKSpriteNode
            levelCOmpletedScreen.color = .clear
            levelCOmpletedScreen.run(actionScale0)
            
            
            geniusScreen.run(actionScale0)
            
            levelFailed = childNode(withName: "LevelFailed") as! SKSpriteNode
            levelFailed.color = .clear
            levelFailed.run(actionScale0)
            
            
            gameState.enter(WaitingForTap.self)
            
            loadLevel(level: level)
            loadLevelCOmpletedScreenNode()
            
            paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            
            Totalscore = (Utility.sharedInstance.userDefault?.integer(forKey: "totalscore"))!
            //baseBall = SKSpriteNode.init(imageNamed: "ball")//childNode(withName: BallCategoryName) as! SKSpriteNode
            
            Utility.sharedInstance.isSound = (Utility.sharedInstance.userDefault?.bool(forKey: "music"))!
            soundNode = self.childNode(withName: "sounds") as! SKSpriteNode
            soundNode.texture = SKTexture.init(imageNamed: "soundoff")
            soundNode.isHidden = true
            if(Utility.sharedInstance.isSound){
                soundNode.texture = SKTexture.init(imageNamed: "soundon")
            }
            soundNode.run(actionScale0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAdd"), object: nil)
        }
    }
    
    
    func addPhysicsWorld(){
        // 1.
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.mass = 1000
        // 2.
        borderBody.friction = 0
        borderBody.density = 100.0
        // 3.
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        
        Utility.sharedInstance.baseBall = ball.copy() as! SKSpriteNode
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
        
        bottom.physicsBody?.categoryBitMask = BottomCategory
        ball.physicsBody?.categoryBitMask = BallCategory
        paddle.physicsBody?.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        
        ball.physicsBody?.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        
        let trailNode = SKNode()
        trailNode.zPosition = 1
        addChild(trailNode)
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)
    } 
    
    func loadLevel(level:Int){
        
        score = 0
        totalBallCount = 0
        levelText.text = "Level-\(level)"
        
        jsonParser.readTheJSONFile(fileName: "level\(level)")
        
        
        let eachRowLevelData = jsonParser.getLevelDetail()
        
        for i in 0..<numberOfBlocks + 1 {
            let block = self.childNode(withName: "brick\(i)") as! SKSpriteNode //SKSpriteNode(imageNamed: "blackbrick")
            
            block.isHidden = true
            
            for levelRow in eachRowLevelData {
                if i == levelRow.tileIndex{
                    block.texture = levelRow.texture
                    block.isHidden = false
                    block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
                    block.physicsBody?.allowsRotation = false
                    block.physicsBody?.friction = 0.0
                    block.physicsBody?.affectedByGravity = false
                    block.physicsBody?.isDynamic = false
                    
                    if(levelRow.isMoving){
                        block.physicsBody?.isDynamic = true
                        block.physicsBody?.pinned = true
                        block.physicsBody?.allowsRotation = true
                        block.zRotation = 90
                    }
                    block.name = BlockCategoryName
                    block.physicsBody?.categoryBitMask = BlockCategory
                    block.zPosition = 2
                    block.userData = ["level":levelRow]
                    
                }
            }
            //addChild(block);.
        }
        
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnPaddle = true
            
        case is Playing:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            touchPoint = touchLocation
            
            if let body = physicsWorld.body(at: touchLocation) {
                if body.node!.name == PaddleCategoryName {
                    isFingerOnPaddle = true
                }
            }
            
        //case is GameOver:
            
        default:
            break
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        var newScene = SKScene()
        let touchedNode = self.atPoint(pos)
        if(touchedNode.name == "menu"){
            newScene = MenuScene(fileNamed:"MenuScene")!
            newScene.scaleMode = .fill
            let reveal = SKTransition.flipHorizontal(withDuration: 1)
            self.view?.presentScene(newScene, transition: reveal)
            levelFailed.run(actionScale0)
            levelCompletedText.run(actionScale0)
        }else if(touchedNode.name == "nextlevel" || touchedNode.name == "reset" ){
            
            newScene = GameScene(fileNamed:"GameScene")!
            newScene.scaleMode = .fill
            let reveal = SKTransition.flipHorizontal(withDuration: 1)
            self.view?.presentScene(newScene, transition: reveal)
            levelCompletedText.run(actionScale0)
            levelFailed.run(actionScale0)
            
        }else if(touchedNode.name == "sounds"){
            Utility.sharedInstance.isSound = !Utility.sharedInstance.isSound
            
            soundNode.texture = SKTexture.init(imageNamed: "soundoff")
            Utility.sharedInstance.userDefault?.set(Utility.sharedInstance.isSound, forKey: "music")
            
            if(Utility.sharedInstance.isSound){
                soundNode.texture = SKTexture.init(imageNamed: "soundon")
            }
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1.
        if isFingerOnPaddle {
            // 2.
            let touch = touches.first
            if let touchLocation = touch?.location(in: self),
                let previousLocation = touch?.previousLocation(in: self) {
                var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
                // 5.
                paddleX = max(paddleX, paddle.size.width/2)
                paddleX = min(paddleX, size.width - paddle.size.width/2)
                // 6.
                paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
                
                if(touchLocation.x - previousLocation.x > -10){
                    Utility.sharedInstance.isMovingDirection = true
                }else{
                    Utility.sharedInstance.isMovingDirection = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState.currentState is Playing {
            // 1.
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            // 2.
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if gameState.currentState is Playing {
            // 1.
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            // 2.
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            // React to contact with bottom of screen
            if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory && firstBody.node?.isHidden == false{
                
                if let userData = firstBody.node?.userData{
                    if userData.object(forKey:"multiple") != nil{
                        firstBody.node?.removeFromParent()
                        firstBody.node?.isHidden = true
                    }
                }else{
                    gameState.enter(GameOver.self)
                    gameWon = false
                }
            }
            // React to contact with blocks
            if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
                
                if let nodeData = secondBody.node?.userData?.object(forKey: "level") as? LevelModel {
                    if(nodeData.isMultiple){
                        for _ in 0...1{
                            let ball = addBall(size: 40.0, withPosition: CGPoint.init(x: self.size.width/2, y: 300))
                            ball.texture = SKTexture.init(imageNamed: "Ball_17")
                            ball.userData = ["multiple":true]
                            //ball.physicsBody!.applyImpulse(CGVector(dx: randomFloat(from: -10.0, to: 10.0), dy: randomFloat(from: 1, to: 10.0)))
                            var y = randomDirection();
                            
                            y = y < 0 ? -y : y
                            
                            ball.physicsBody?.applyImpulse(CGVector(dx: randomDirection(), dy: y))
                            totalBallCount = totalBallCount + 1
                        }
                    }
                    
                    if(nodeData.isLaser){
                        var y = randomDirection();
                        for i in 0...3{
                            y = y - 1
                            let ball = addBall(size: 20.0, withPosition: CGPoint.init(x: paddle.position.x - paddle.size.width/2, y: (paddle.position.y - paddle.size.height/2) + CGFloat(i * 30)))
                            ball.physicsBody?.applyImpulse(CGVector(dx:0, dy: abs(y)))
                            ball.userData = ["islaser":true]
                            
                            let ball1 = addBall(size: 20.0, withPosition: CGPoint.init(x: paddle.position.x + paddle.size.width/2, y: (paddle.position.y - paddle.size.height/2) + CGFloat(i * 30)))
                            ball1.physicsBody?.applyImpulse(CGVector(dx:0, dy: abs(y)))
                            ball1.userData = ["islaser":true]
                        }
                    }
                    
                }
                if(secondBody.node != nil){
                    breakBlock(secondBody.node!)
                }
                if(firstBody.node != nil){
                    if let userDate = firstBody.node?.userData{
                        if userDate.object(forKey:"islaser") != nil{
                            breakBlock(firstBody.node!)
                        }
                    }
                }
                if isGameWon() {
                    gameState.enter(GameOver.self)
                    gameWon = true
                }
            }
            
            if (firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory && isFingerOnPaddle){
                firstBody.velocity.dx = Utility.sharedInstance.isMovingDirection ? -firstBody.velocity.dx:firstBody.velocity.dx
                if (Utility.sharedInstance.isMovingDirection && firstBody.velocity.dx < 0){
                    firstBody.velocity.dx = -firstBody.velocity.dx
                }
                if (firstBody.velocity.dx > 0 && !Utility.sharedInstance.isMovingDirection){
                    firstBody.velocity.dx = -firstBody.velocity.dx
                }
            }
            // 1.
            if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
                
                if let userDate = firstBody.node?.userData{
                    if userDate.object(forKey:"islaser") != nil{
                        breakBlock(firstBody.node!)
                    }
                }else if Utility.sharedInstance.isSound{
                    run(blipSound)
                }
            }
            
            // 2.
            if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory && Utility.sharedInstance.isSound{
                run(blipPaddleSound)
            }
        }
    }
    
    
    func addBall(size:CGFloat,withPosition Position:CGPoint)-> SKSpriteNode{
        let ball = SKSpriteNode.init(texture: Utility.sharedInstance.baseBall.texture)
        ball.position = Position//CGPoint.init(x: self.size.width/2, y: 300)
        ball.size  = CGSize.init(width: size, height:size)
        
        ball.physicsBody = Utility.sharedInstance.baseBall.physicsBody?.copy() as! SKPhysicsBody//SKPhysicsBody.init(circleOfRadius: size/2)
        ball.zPosition = 2
        //ball.physicsBody?.restitution = 0.0
        // ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        ball.physicsBody?.categoryBitMask = BallCategory
        ball.physicsBody?.mass = 0.006
        
        addChild(ball)
        
        let trailNode = SKNode()
        trailNode.zPosition = 1
        addChild(trailNode)
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)
        
        return ball
        
    }
    
    // MARK: - Helpers
    func breakBlock(_ node: SKNode){
        
        if let nodeData = node.userData?.object(forKey: "level") as? LevelModel  {
            if(nodeData.textureValue == 0 ){
                return
            }else if(nodeData.textureValue > 0 && nodeData.textureValue < 1024){
                score =  score + nodeData.textureValue
                scoreText.text = "Score : \(score)/2048"
            }
            
        }
        if(Utility.sharedInstance.isSound){
            run(bambooBreakSound)
        }
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    func randomFloat(from:CGFloat, to:CGFloat) -> CGFloat {
        let rand:CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    func isGameWon() -> Bool {
        
        if(score >= 2048){
            if(level < Utility.sharedInstance.totalLevel){
                level = level + 1
                Utility.sharedInstance.userDefault?.set(level, forKey: "level")
                Utility.sharedInstance.userDefault?.synchronize()
                submitGamecenterScore()
            }else if(level == Utility.sharedInstance.totalLevel){
                submitGamecenterScore()
                Utility.sharedInstance.userDefault?.set(true, forKey: "newLevel")
                levelCompletedText.run(actionScale0)
                geniusScreen.run(actionScale1)
                Utility.sharedInstance.userDefault?.synchronize()
            }
            return true
        }else{
            return false
        }
        
    }
    
    deinit{
        for  view in self.children{
            view.removeFromParent();
        }
        
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    func submitGamecenterScore(){
        Totalscore = Totalscore + score
        Utility.sharedInstance.userDefault?.set(Totalscore, forKey: "totalscore")
        iAppsGameCenter.sharedInstance.submitScore()
    }
}


/// GameEndScreen

extension GameScene {
    func loadLevelCOmpletedScreenNode(){
        levelCompletedText = levelCOmpletedScreen.childNode(withName: "levelcompletedtext") as! SKLabelNode
        levelpointText = levelCOmpletedScreen.childNode(withName: "levelscoretext") as! SKLabelNode
        totalpointText = levelCOmpletedScreen.childNode(withName: "totalscoretext") as! SKLabelNode
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = self.randomFloat(from: 7.0, to: 10.0)
        if self.randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
}
