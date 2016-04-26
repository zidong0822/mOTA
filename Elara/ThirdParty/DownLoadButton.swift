//
//  DownLoadButton.swift
//  Elara
//
//  Created by HeHongwe on 15/12/18.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit

class DownLoadButton:UIButton{


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2,4);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 5;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}


