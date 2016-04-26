//
//  ServiceApi.swift
//
//
//  Created by HeHongwe on 15/11/20.
//  Copyright © 2015年 harvey. All rights reserved.
//


import UIKit

class ServiceApi: NSObject {
   
    static var host:String = "https://mota.microduino.cn"
    
    internal class func getProjects() -> String {
        
        return "\(host)/api/v1.0/p"
    }
    
    internal class func ProjectSource(projectId:String) -> String {
        
        return "\(host)/api/v1.0/p/\(projectId)/m"
    }
    
    internal class func getSketches(modelId:String) -> String {
 
        return "\(host)/api/v1.0/m/\(modelId)/s"
    }
    
    internal class func getCores()->String{
        
        return "\(host)/api/v1.0/cores"
        
    }
    internal class func getSketches(offest:Int,limit:Int,core:String)->String{
    
        return "\(host)/api/v1.0/sketches?offset=\(offest)&limit=\(limit)&core=\(core)"
    
    }
    internal class func getSearch(station:String)->String{
    
        return "\(host)/api/v1.0/search?q=\(station)"
    }
    
    
    
}
