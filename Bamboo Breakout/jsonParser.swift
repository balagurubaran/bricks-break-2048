//
//  jsonParser.swift
//  Checkwithus
//
//  Created by Kalingarayan, Balagurubaran on 8/22/16.
//  Copyright © 2016 Kalingarayan, Balagurubaran. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class JSONParser {
    
    private var levelDetail:[LevelModel] = []
    
    func readTheJSONFile(fileName:String){
        let fm = FileManger()
        let fileContent : String =  fm.ReadFile(fileName) as String
        parseTheJSON(jsonContent: fileContent)
    }
    
    func parseTheJSON(jsonContent:String) {
         let fileData : Data = jsonContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        
        do {
            if let json: NSDictionary = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                
                for (_,value) in json{
                    let eachrowdata = LevelModel()
                    let eachRow = value as! NSDictionary
                    
                    eachrowdata.tileIndex = eachRow.object(forKey: "index") as! Int
                    eachrowdata.textureValue = eachRow.object(forKey: "value") as! Int
                    eachrowdata.texture = SKTexture.init(imageNamed: "\(eachrowdata.textureValue)")
                    if((eachRow.object(forKey: "ismoving")) != nil){
                        eachrowdata.isMoving = eachRow.object(forKey: "ismoving") as! Bool
                    }else{
                        eachrowdata.isMoving = false
                    }
                    
                    if let value = eachRow.object(forKey: "ismultiple") {
                           eachrowdata.isMultiple = value as! Bool
                    }else {
                        eachrowdata.isMultiple = false
                    }
                    
                    if let value = eachRow.object(forKey: "islaser") {
                        eachrowdata.isLaser = value as! Bool
                    }else {
                        eachrowdata.isLaser = false
                    }
                    levelDetail.append(eachrowdata)
                }
            }
        }catch{
            
        }
    }
    
    func getLevelDetail() ->[LevelModel]{
        return levelDetail;
    }
}
