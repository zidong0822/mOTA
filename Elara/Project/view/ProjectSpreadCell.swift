//
//  ProjcetTableViewCell.swift
//  Elara
//
//  Created by HeHongwe on 15/12/1.
//  Copyright © 2015年 harvey. All rights reserved.
//
import Haneke
class ProjectSpreadCell: UITableViewCell {
    
    var wifiImageView:UIImageView!
    var projectImageView:UIImageView!
    var audioImageView:UIImageView!
    var projectNameLabel:UILabel!
    var authorNameLabel:UILabel!
    var downButton:UIButton!
    var discoverButton:UIButton!
    var bushButton:UIButton!
    var descLabel:UILabel!
    var photoArray = NSMutableArray()
 
    func ProjectSpreadCell(tablecell:UITableViewCell,indexPath:NSIndexPath,cellData:NSDictionary,isConnect:Bool)->UITableViewCell{
 
        tablecell.backgroundColor = UIColor(rgba:"#FFFFFF")
        tablecell.layer.cornerRadius = 5
        tablecell.layer.masksToBounds = true
        
        
        self.projectImageView = UIImageView(frame:CGRectMake(10,10,100,100))
        self.projectImageView.sd_setImageWithURL(NSURL(string:"\(ServiceApi.host)\(cellData["picture"]!)"), placeholderImage:UIImage(named:"gray_sensor"))
        tablecell.contentView.addSubview(projectImageView)
        
        self.projectNameLabel = UILabel(frame:CGRectMake(120,20,SCREEN_WIDTH,30))
        self.projectNameLabel.font = UI_FONT_17
        self.projectNameLabel.text = cellData["name"] as? String
        tablecell.contentView.addSubview(projectNameLabel)
        
        self.authorNameLabel = UILabel(frame:CGRectMake(120,30,150,50))
        self.authorNameLabel.font = UI_FONT_13
        self.authorNameLabel.text = cellData["author_user_name"] as? String
        self.authorNameLabel.numberOfLines = 0
        tablecell.contentView.addSubview(authorNameLabel)
        
        self.descLabel = UILabel(frame:CGRectMake(120,100,200,30))
        self.descLabel.font = UI_FONT_13
        self.descLabel.text = "\(cellData["desc"]!)"
        tablecell.contentView.addSubview(descLabel)
        
        self.downButton = UIButton(frame:CGRectMake(SCREEN_WIDTH-80,45, 35, 35))
        self.downButton.layer.cornerRadius = 35/2
        self.downButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.downButton.layer.shadowOffset = CGSizeMake(2,2);
        self.downButton.layer.shadowOpacity = 0.5;
        self.downButton.layer.shadowRadius = 2;//
        self.downButton.backgroundColor = UIColor.blackColor()
        tablecell.contentView.addSubview(downButton)
        self.discoverButton = UIButton(frame:CGRectMake(110,140,SCREEN_WIDTH-150, 40))
        self.discoverButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.discoverButton.layer.shadowOffset = CGSizeMake(2,2);
        self.discoverButton.layer.shadowOpacity = 0.5;
        self.discoverButton.layer.shadowRadius = 2;
        self.discoverButton.layer.cornerRadius = 3
        
        if(isConnect){
            self.discoverButton.backgroundColor = UIColor(rgba:"#00B2FF")
            self.discoverButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        }else{
            self.discoverButton.backgroundColor = UIColor(rgba:"#000000")
            self.discoverButton.setTitle("Scan Uploads",forState: UIControlState.Normal)
            self.discoverButton.setTitleColor(UIColor(rgba:"#00B2FF"), forState: UIControlState.Normal)
        }
       
        tablecell.contentView.addSubview(discoverButton)
       
        self.bushButton = UIButton(frame:CGRectMake(110,190,SCREEN_WIDTH-150, 40))
        self.bushButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.bushButton.layer.shadowOffset = CGSizeMake(2,2);
        self.bushButton.layer.shadowOpacity = 0.5;
        self.bushButton.layer.shadowRadius = 2;
        self.bushButton.layer.cornerRadius = 3
        self.bushButton.backgroundColor = UIColor(rgba:"#A3A3A3")
        self.bushButton.setTitle("upload",forState: UIControlState.Normal)
        self.bushButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tablecell.contentView.addSubview(bushButton)

        let photoArray = NSMutableArray(array:cellData["module_icons"] as! NSArray)
        
        for var i = 0 ;i<photoArray.count ; i++ {
            let  sdImageView = UILabel()
            sdImageView.tag = i
            let widths = 30 as CGFloat, heights = 30 as CGFloat, margin = 10 as CGFloat, startX = 120 as CGFloat, startY = 70 as CGFloat;
            let  row = CGFloat(i/10)
            let column = CGFloat(i%10)
            let x = startX+(column*(widths+margin))
            let  y = startY + row * (heights + margin)
            sdImageView.frame = CGRectMake(x, y, widths, heights)
            sdImageView.font = UIFont(name:"microduino-icon", size:30)
            sdImageView.text = getFontName(photoArray[i] as! String)
            tablecell.contentView.addSubview(sdImageView)
            
        }
        return tablecell
    }
    

}
