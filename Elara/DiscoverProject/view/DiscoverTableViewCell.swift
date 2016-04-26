//
//  DiscoverTableViewCell.swift
//  Elara
//
//  Created by HeHongwe on 15/12/2.
//  Copyright © 2015年 harvey. All rights reserved.
//

class DiscoverTableViewCell: UITableViewCell {
    
    
    
    var wifiImageView:UILabel!
    var projectNameLabel:UILabel!
    var desLabel:UILabel!
    var downButton:UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.backgroundColor = UIColor(rgba:"#3F3F3F")
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.projectNameLabel = UILabel(frame:CGRectMake(60,15,80,30))
        self.projectNameLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(projectNameLabel)
        
        self.desLabel = UILabel(frame:CGRectMake(180,15,100,30))
        self.desLabel.textColor = UIColor.whiteColor()
        self.desLabel.font = UIFont(name:"Arial", size: 13)
        self.contentView.addSubview(desLabel)
        
        self.wifiImageView = UILabel(frame:CGRectMake(20,20, 20, 20))
        self.wifiImageView.font = UIFont(name:"microduino-icon", size:20)
        self.wifiImageView.textColor = UIColor.whiteColor()
        self.contentView.addSubview(self.wifiImageView)
        
        self.downButton = UIButton(frame:CGRectMake(SCREEN_WIDTH-60,20, 20, 20))
        self.downButton.setImage(UIImage(named:"unselect_bg"), forState:UIControlState.Normal)
        self.contentView.addSubview(downButton)
        
    }
    
    func loadDataToCell(dict:NSDictionary){
    
        self.projectNameLabel.text = dict["name"] as? String
        self.desLabel.text = dict["value"] as? String
        self.wifiImageView.text = getFontName(dict.objectForKey("icon") as! String)
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
}