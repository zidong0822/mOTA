//
//  UIScreen+Additions.swift
//  Elara
//
//  Created by HeHongwe on 15/12/3.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation

extension UIScreen {
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
}