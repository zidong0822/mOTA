//
//  GuideVC.swift
//  Guide+Banner
//
//  Created by Mac OS on 15/10/23.
//  Copyright © 2015年 LJ. All rights reserved.
//

import UIKit

private let kWIDTH = UIScreen.mainScreen().bounds.width
private let kHEIGHT = UIScreen.mainScreen().bounds.height
private let minX = 0
private let minY = 0
private let navHeight = 64

class GuideVC: UIViewController ,UIScrollViewDelegate{

    var startClosure:(() -> Void)?
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var mutableArray: NSMutableArray?
    let x = CGFloat(Float(minX))
    let y = CGFloat(Float(minY))
    let navH = CGFloat(Float(navHeight))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        createInitView()
    }

    func createInitView() {
        
        let arr = ["guide1.jpg","guide2.jpg","guide3.jpg","guide4.jpg","guide5.jpg"]
        
        if self.scrollView == nil {
            self.scrollView = UIScrollView.init(frame: CGRectMake(x, y, kWIDTH, kHEIGHT))
            self.scrollView.delegate = self
            self.scrollView.pagingEnabled = true
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            self.view.addSubview(self.scrollView)
            
            self.scrollView.contentSize = CGSizeMake(kWIDTH * CGFloat(Float(arr.count)), kHEIGHT)
            
            for var i = 0 ;i < arr.count ; i++ {
                let index = CGFloat(Float(i))
                let imgView = UIImageView.init(frame: CGRectMake(index * kWIDTH, y, kWIDTH, kHEIGHT))
                imgView.image = UIImage(named: arr[i])
                self.scrollView.addSubview(imgView)
                
                if i == arr.count - 1 {
                    imgView.userInteractionEnabled = true
                    
                    let button = UIButton.init(type: UIButtonType.Custom)
                    button.frame = CGRectMake((kWIDTH - 200) / 2, kHEIGHT - 94, 200, 45)
                    button.setTitle("立即体验", forState: UIControlState.Normal)
                    button.backgroundColor = UIColor.orangeColor()
                    button.titleLabel?.font = UIFont.systemFontOfSize(18)
                    button.layer.cornerRadius = 5
                    button.layer.masksToBounds = true
                    button.addTarget(self, action: "clickButton:", forControlEvents: UIControlEvents.TouchUpInside)
                    imgView.addSubview(button)
                }
            }
        }
        
        if self.pageControl == nil {
            self.pageControl = UIPageControl.init(frame: CGRectMake((kWIDTH - 150) / 2, kHEIGHT - 45, 150, 30))
            self.pageControl.numberOfPages = arr.count
            self.view.addSubview(self.pageControl)
            self.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
            self.pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        }
    }
    
    func clickButton(sender: UIButton) {
        
        startClosure!()
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / kWIDTH
        self.pageControl.currentPage = Int(index)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
