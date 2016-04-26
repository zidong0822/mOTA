//
//  YHHeaderView.swift
//  Elara
//
//  Created by HeHongwe on 15/11/23.
//  Copyright © 2015年 harvey. All rights reserved.
//
import UIKit
class YHHeaderView : UIView{

    
    var viewController:UIViewController!
    var scrollView:UIScrollView!
    var backImageView:UIImageView!
    var headerImageView:UIImageView!
    var titleLabel:UILabel!
    var subTitleLabel:UILabel!
    var prePoint:CGPoint!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        
      
    }
    
    func updataFrame(frame:CGRect,backImageURL:NSString,headerImageURL:NSString,title:NSString,subTitle:NSString){
    
        backImageView = UIImageView(frame:CGRectMake(0, -0.5*frame.size.height, frame.size.width, frame.size.height*1.5))
        backImageView.image = UIImage(named:"background")
        backImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        headerImageView = UIImageView(frame:CGRectMake(frame.size.width*0.5-0.125*frame.size.height, 0.25*frame.size.height, 0.25*frame.size.height, 0.25*frame.size.height))
        headerImageView.image = UIImage(named:"logoB")
        
        titleLabel = UILabel(frame:CGRectMake(0, 0.6*frame.size.height, frame.size.width, frame.size.height*0.2))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.boldSystemFontOfSize(20)
        titleLabel.text = title as String
        titleLabel.textColor = UIColor.whiteColor()
        
        subTitleLabel = UILabel(frame:CGRectMake(0, 0.85*frame.size.height, frame.size.width, frame.size.height*0.1))
        subTitleLabel.textAlignment = NSTextAlignment.Center
        subTitleLabel.font = UIFont.boldSystemFontOfSize(12)
        subTitleLabel.text = subTitle as String
        subTitleLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(backImageView)
        self.addSubview(headerImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.clipsToBounds = true
        
    
    
    }
    
     override func willMoveToSuperview(newSuperview: UIView?) {
    
        self.viewController.navigationController?.navigationBarHidden = true
        self.scrollView.addObserver(self, forKeyPath:"contentOffset", options:NSKeyValueObservingOptions.New, context:nil)
        self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height-20,0, 0, 0)
        
        
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

         let newOffset = change!["new"]?.CGPointValue
            updateSubViewsWithScrollOffset(newOffset!)
        
    }
    func updateSubViewsWithScrollOffset(newOffset:CGPoint){
    
        let destinaOffset:CGFloat = -64
        let startChangeOffset:CGFloat = -(self.scrollView.contentInset.top)
        var x:CGFloat = 0
        if newOffset.y<startChangeOffset{
        
            x = startChangeOffset
        
        }else{
        
            if(newOffset.y>destinaOffset){
            x = destinaOffset
            }else{
            x = newOffset.y
            }
        }
        let newOffset1 = CGPointMake(newOffset.x,x)
        
        let titleDestinateOffset = self.frame.size.height-40;
        let newY = -newOffset1.y-self.scrollView.contentInset.top;
        let d = destinaOffset-startChangeOffset;
        let alpha = 1-(newOffset1.y-startChangeOffset)/d;
     
        self.subTitleLabel.alpha = alpha;
        self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
        self.backImageView.frame = CGRectMake(0, -0.5*self.frame.size.height+(1.5*self.frame.size.height-64)*(1-alpha), self.backImageView.frame.size.width, self.backImageView.frame.size.height);
        
        self.titleLabel.frame = CGRectMake(0, 0.6*self.frame.size.height+(titleDestinateOffset-0.6*self.frame.size.height)*(1-alpha), self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        self.titleLabel.font = UIFont.boldSystemFontOfSize(16+alpha*4)

        
    
    
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

}