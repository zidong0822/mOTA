//
//  NavigationView.swift
//  Elara
//
//  Created by HeHongwe on 15/12/3.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    var delegate: navigationViewDelegate?
    var titleLabel:UILabel!
    var nameLabel:UILabel!
    var helpLabel:UILabel!
    var logoButton:UIButton!
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "coreChange:", name: "coreChange", object: nil)
        
        let navigationView = UIImageView(frame:CGRectMake(0,0,SCREEN_WIDTH,64))
        navigationView.image = UIImage(named:"nav_bg")
        navigationView.userInteractionEnabled = true
        self.addSubview(navigationView)
        let navigationViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:"navigationViewAction:");
        navigationView.addGestureRecognizer(navigationViewTapGestureRecognizer)
        
        
        logoButton = UIButton(frame:CGRectMake(15,15,40,40))
        logoButton.layer.cornerRadius = 20
        logoButton.layer.masksToBounds = true
        logoButton.backgroundColor = UIColor(rgba:"#E89111")
        logoButton.titleLabel!.font = UIFont(name:"microduino-icon", size:20)
        logoButton.setTitle(getFontName("icon-m-help"), forState: UIControlState.Normal)
        logoButton.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        navigationView.addSubview(logoButton)
        
        
        titleLabel = UILabel(frame:CGRectMake(70,10,120,30))
        titleLabel.textColor = UIColor(rgba:"#B4F91D")
        titleLabel.font = UI_FONT_17
        navigationView.addSubview(titleLabel)
        
        helpLabel = UILabel(frame:CGRectMake(40,0,SCREEN_WIDTH-40,64))
        helpLabel.textColor = UIColor.whiteColor()
        helpLabel.textAlignment = NSTextAlignment.Center
        helpLabel.textColor = UIColor.whiteColor()
        navigationView.addSubview(helpLabel)
        
        nameLabel = UILabel(frame:CGRectMake(70,30,120,30))
        nameLabel.font = UI_FONT_13
        nameLabel.textColor = UIColor.whiteColor()
        navigationView.addSubview(nameLabel)
        
        if((nameLabel.text) == nil){
        
             helpLabel.text = "Type here to select core type"
        
        }

    }
    
    func loadDataToNavigation(data:NSMutableDictionary){
    
        self.titleLabel.text = data.objectForKey("name") as? String
        self.logoButton.backgroundColor = UIColor(rgba:"#AEE519")
        self.nameLabel.text = data.objectForKey("value") as? String
        self.helpLabel.hidden = true
        self.logoButton.setTitle(getFontName(data.objectForKey("icon") as! String), forState: UIControlState.Normal)
        
    }
    func coreChange(title:NSNotification){
        
        let coreTitle = title.object as! NSDictionary
        
        if (coreTitle.objectForKey("value") != nil){
            
            titleLabel.text = coreTitle.objectForKey("name") as? String
            nameLabel.text = coreTitle.objectForKey("value") as? String
            logoButton.backgroundColor = UIColor(rgba:"#AEE519")
            logoButton.setTitle(getFontName(coreTitle.objectForKey("icon") as! String), forState: UIControlState.Normal)
            helpLabel.hidden = true
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navigationViewAction(tap:UITapGestureRecognizer){
    
      delegate?.navigationViewAction(tap)
    
    }
    
}


    protocol navigationViewDelegate {
    
     func navigationViewAction(tap:UITapGestureRecognizer)
   
    
}