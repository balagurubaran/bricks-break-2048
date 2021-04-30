//
//  GameViewController.swift
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

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
//            //print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
//            switch UIDevice.current.userInterfaceIdiom {
//            case .phone:
//                bannerView = GADBannerView.init(adSize: kGADAdSizeBanner, origin: CGPoint.init(x: 0, y: self.view.frame.size.height - kGADAdSizeBanner.size.height))
//            case .pad:
//                bannerView = GADBannerView.init(adSize: kGADAdSizeLeaderboard, origin: CGPoint.init(x: 0, y: self.view.frame.size.height - kGADAdSizeFullBanner.size.height))
//            default:
//                bannerView = GADBannerView.init(adSize: kGADAdSizeBanner, origin: CGPoint.init(x: self.view.frame.size.width/2 - kGADAdSizeBanner.size.width/2, y: self.view.frame.size.height - kGADAdSizeFullBanner.size.height))
//
//            }
            AdMob.shared.initAds()
        }
        
        iAppsGameCenter.sharedInstance.authenticateLocalPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
