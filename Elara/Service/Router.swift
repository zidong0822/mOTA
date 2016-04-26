//
//  Router.swift
//  
//
//  Created by HeHongwe on 15/11/20.
//  Copyright © 2015年 harvey. All rights reserved.
//
import UIKit
import Alamofire



enum Router: URLRequestConvertible {
   
    static var token: String?
    
    //Restfull api
    case Projects()
    case ProjectSource(projectId:String)
    case Sketches(offset:Int,limit:Int,core:String)
    case Cores()
    case Search(station:String)
    
    
    var method: Alamofire.Method {
        switch self {
        case .Projects:
            return .GET
        case .ProjectSource:
            return .GET
        case .Sketches:
            return .GET
        case .Cores():
            return .GET
        case .Search:
            return .GET
        }
        
        
        
    }
    var path: String {
        switch self {
        case .Projects():
            return ServiceApi.getProjects()
        case .ProjectSource(let projectId):
            return ServiceApi.ProjectSource(projectId)
        case .Sketches(let offset,let limit,let core):
            return ServiceApi.getSketches(offset,limit:limit,core:core)
        case .Cores():
            return ServiceApi.getCores()
        case .Search(let station):
            return ServiceApi.getSearch(station)
        }
        
    }
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: path)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = Router.token {
            mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "token")
        }
         
        
        switch self {
            default:
            return mutableURLRequest
        }
    }
}
