//
//  gameCenter.swift
//  iAppsCopter
//
//  Created by Balagurubaran Kalingarayan on 2/18/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import GameKit
import GameplayKit

let leaderboardID = "bricksbreak2048_top"

class iAppsGameCenter:UIViewController,GKGameCenterControllerDelegate{
    
    
    let gcVC: GKGameCenterViewController = GKGameCenterViewController()

    static let sharedInstance : iAppsGameCenter = {
        let instance = iAppsGameCenter()
        
        instance.gcVC.gameCenterDelegate = instance
        instance.gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        instance.gcVC.leaderboardIdentifier = leaderboardID
        
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(instance.submitScore),
            name: NSNotification.Name(rawValue: "submitScore"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(instance.showGameLeaderboard),
            name: NSNotification.Name(rawValue: "showGameLeaderboard"),
            object: nil)
        return instance
    }()
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        let viewCOntroller =  UIApplication.shared.keyWindow?.rootViewController
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                viewCOntroller?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: Error?) -> Void in
                    if error != nil {
                        print(error ?? "Failed")
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error ?? "Failed")
            }
            
        }
        
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func showGameLeaderboard() {
        let viewCOntroller =  UIApplication.shared.keyWindow?.rootViewController
        viewCOntroller?.present(gcVC, animated: true, completion: nil)
    }
    
    func scoreAndRank(){
        let leaderBoard : GKLeaderboard = GKLeaderboard()
        
        leaderBoard.timeScope = .allTime
        leaderBoard.range = NSMakeRange(1, 1)
        leaderBoard.identifier = "Your Leaderboard ID"
        leaderBoard.loadScores { (score, error) in
            if(error == nil){
                if((score?.count)! > 0){
                    
                    let playerScore : GKScore = leaderBoard.localPlayerScore!
                    
                    //let rank : NSInteger = playerScore.rank
                    
                    Utility.sharedInstance.userDefault?.set(playerScore.rank, forKey: "rank")
                 //   iwatchData.sharedInstance.rank = playerScore.rank
                }

            }
        }

    }
    
    @objc func submitScore() {
        #if DEBUG
            return;
        #endif
        
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64((Utility.sharedInstance.userDefault?.integer(forKey: "totalscore"))!)
        GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
            print(error?.localizedDescription ?? "")
        })
        
        if( (Utility.sharedInstance.userDefault?.integer(forKey: "score"))! < Int(sScore.value)){
             Utility.sharedInstance.userDefault?.set(sScore.value, forKey: "score")
        }
    }

}
