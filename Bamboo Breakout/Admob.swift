//
//  Admob.swift
//  bricks break 2048
//
//  Created by Balagurubaran on 5/27/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdMob{
    
    static let shared:AdMob = AdMob()
    private static var interstitial: GADInterstitial?
    private static  let request = GADRequest()
    
    func initAds(){
        AdMob.interstitial = GADInterstitial(adUnitID: "ca-app-pub-4013951321415401/8019891091")
        AdMob.interstitial?.load(GADRequest())
    }
    
    func addInterstitial(){
        if AdMob.interstitial?.isReady ?? false{
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            AdMob.interstitial?.present(fromRootViewController: viewController)
        }
    }
}
