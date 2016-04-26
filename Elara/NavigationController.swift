//
//  NavigationController.swift
//  Elara
//
//  Created by HeHongwe on 15/11/20.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(red: 36.0/255.0, green: 190.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
