//
//  ProjcetTableViewCell.swift
//  Elara
//
//  Created by HeHongwe on 15/12/1.
//  Copyright © 2015年 harvey. All rights reserved.
//
import Haneke
import SDWebImage
class ProjcetTableViewCell: UITableViewCell {
    

    var sdImageView:UIImageView!
    var projectImageView:UIImageView!
    var projectNameLabel:UILabel!
    var authorNameLabel:UILabel!
    var downButton:UIButton!
    var photoArray = NSMutableArray()
    var downloadCount:UILabel!

    func ProjectTableCell(tablecell:UITableViewCell,indexPath:NSIndexPath,cellData:NSDictionary)->UITableViewCell{
        
        tablecell.backgroundColor = UIColor(rgba:"#FFFFFF")
        tablecell.layer.cornerRadius = 5
        tablecell.layer.masksToBounds = true
       
        self.projectImageView = UIImageView(frame:CGRectMake(10,10,100,100))
        tablecell.contentView.addSubview(projectImageView)
        
        self.projectNameLabel = UILabel(frame:CGRectMake(120,20,SCREEN_WIDTH,30))
        self.projectNameLabel.font = UI_FONT_17
        tablecell.contentView.addSubview(projectNameLabel)
        
        self.authorNameLabel = UILabel(frame:CGRectMake(120,40,150,30))
        self.authorNameLabel.font = UI_FONT_13
        tablecell.contentView.addSubview(authorNameLabel)
        
        self.downloadCount = UILabel(frame:CGRectMake(SCREEN_WIDTH-80,50,30,30))
        self.downloadCount.font = UI_FONT_13
        self.downloadCount.textAlignment = NSTextAlignment.Center
       // tablecell.contentView.addSubview(downloadCount)
        
        self.downButton = UIButton(frame:CGRectMake(SCREEN_WIDTH-80,45, 35, 35))
        self.downButton.layer.cornerRadius = 35/2
        self.downButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.downButton.layer.shadowOffset = CGSizeMake(2,2);
        self.downButton.layer.shadowOpacity = 0.5;
        self.downButton.layer.shadowRadius = 2;//
        self.downButton.backgroundColor = UIColor.blackColor()
        
        tablecell.contentView.addSubview(downButton)
        
        self.projectImageView.sd_setImageWithURL(NSURL(string:"\(ServiceApi.host)\(cellData["picture"]!)"), placeholderImage:UIImage(named:"gray_sensor"))
        self.projectNameLabel.text = cellData["name"] as? String
        self.authorNameLabel.text = cellData["author_user_name"] as? String
        let downLoadCount = cellData["download_counts"] as! Int
        self.downloadCount.text = "\(downLoadCount)"

        let photoArray = NSMutableArray(array:cellData["module_icons"] as! NSArray)
        
        for var i = 0 ;i<photoArray.count ; i++ {
           let  sdImageView = UILabel()
            sdImageView.tag = i
            let widths = 30 as CGFloat, heights = 30 as CGFloat, margin = 10 as CGFloat, startX = 120 as CGFloat, startY = 30 as CGFloat;
            let  row = CGFloat(1);
            let column = CGFloat(i%5);
            let x = startX+(column*(widths+margin))
            let  y = startY + row * (heights + margin);
            sdImageView.frame = CGRectMake(x, y, widths, heights)
            sdImageView.font = UIFont(name:"microduino-icon", size:30)
            sdImageView.text = getFontName(photoArray[i] as! String)
            tablecell.contentView.addSubview(sdImageView)

        }
        return tablecell
    }
}
