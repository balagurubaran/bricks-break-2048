//
//  FileManager.swift
//  iNewsFeed
//
//  Created by Balagurubaran on 24/11/2014.
//  Copyright (c) 2014 Iappscrazy. All rights reserved.
//

import Foundation


class FileManger{
    
    func ReadFile(_ fileName:String)->String{
        
        let bundle = Bundle.main
        let myFilePath = bundle.path(forResource: fileName, ofType: "json")
        
        //var content:String = String(contentsOfFile: myFilePath!, encoding: String.Encoding.utf8, error: &error)!
        do{
            let content:String = try String(contentsOfFile: myFilePath!, encoding: String.Encoding.utf8)
            return content;
        }
        catch{
        }
        return "Error"
    }
    
    func writeFile(_ fileName:String,fileContent:NSString)->Bool{
        
        return true;
    }
    
    
}
