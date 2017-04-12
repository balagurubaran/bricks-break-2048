//
//  Utility.swift
//  iAppsCopter
//
//  Created by Balagurubaran Kalingarayan on 2/14/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

import Foundation
import GameKit

class Utility {
    var rank:Int = 0

    var gameCount = 0
    var isSound   = true
    let totalLevel = 11
    var isMovingDirection = true
    var previouesLocation = CGPoint()
    var userDefault = UserDefaults.standard
    
    static let sharedInstance : Utility = {
        let instance = Utility()
        //iwatchData.sharedInstance
        return instance
    }()
    

    func addNotification(){
        UIApplication.shared.cancelAllLocalNotifications()
        
        let fireDate =  Calendar.current.date(byAdding: .day, value: 2, to: Date())
        let localNotificcation = UILocalNotification()
        localNotificcation.timeZone = NSTimeZone.default
        localNotificcation.fireDate = fireDate
        localNotificcation.alertTitle = "Fighting Copter - Miss me Miss me"
        localNotificcation.alertBody  =  "Why your waiting, come and beat your best score"
        UIApplication.shared.scheduleLocalNotification(localNotificcation)

    }
    
}
