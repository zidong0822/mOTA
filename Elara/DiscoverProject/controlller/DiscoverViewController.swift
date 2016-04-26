//
//  DiscoverViewController.swift
//  Elara
//
//  Created by HeHongwe on 15/12/2.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class DiscoverViewController: UIViewController{

    var coresList = NSMutableArray()
    var tableIndex:NSInteger = 0
    var coreTitle = NSMutableDictionary()
    var icons = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        layoutUI()
        getCoresData()
    }
    
    /**
     准备子控件方法，在这个方法中我们可以创建并添加子控件到view
     */
    private func prepareUI() {
     
        self.view.backgroundColor = UIColor(rgba:"#262626")
        tableView.registerClass(DiscoverTableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        view.addSubview(tableView)
        view.addSubview(nameLabel)
        view.addSubview(doneButton)
        
    }
    
    
    /**
     约束子控件的方法
     */
    private func layoutUI() {
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(70)
            make.bottom.equalTo(-60)
            make.width.equalTo(SCREEN_WIDTH-20)
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.width.equalTo(SCREEN_WIDTH-20)
            make.height.equalTo(40)
        }
        
        doneButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(60)
        }
    }
    // MARK: - 懒加载
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(rgba:"#262626")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView();
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        return tableView
    }()
    
    lazy var nameLabel:UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Please Select Core Type"
        nameLabel.font = UIFont(name:"Arial", size: 13)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor(rgba:"#7B7B7B")
        return nameLabel
    
    }()
    
    
    lazy var doneButton:UIButton = {
        let doneButton = UIButton()
        doneButton.setBackgroundImage(UIImage(named:"nav_bg"), forState: UIControlState.Normal)
        doneButton.setTitle("DONE", forState: UIControlState.Normal)
        doneButton.titleLabel!.font = UIFont.boldSystemFontOfSize(25)
        doneButton.addTarget(self, action:"backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.setTitleColor(UIColor(rgba:"#AEE519"), forState:UIControlState.Normal)
        return doneButton
    
    }()
}
extension DiscoverViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return coresList.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#262626")
        return view
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#262626")
        return view
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIndentifier :String = "cellIdentifier";
        let cell:DiscoverTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as? DiscoverTableViewCell
        let oneRowData = coresList[indexPath.section] as! NSDictionary
        cell?.loadDataToCell(oneRowData)
        cell?.downButton.addTarget(self, action:"coreSelect:", forControlEvents:UIControlEvents.TouchUpInside)
        cell?.downButton.tag = indexPath.section
        cell!.selectedBackgroundView = UIView(frame:cell!.frame);
        cell!.selectedBackgroundView!.backgroundColor =  UIColor(rgba:"#1A1A1A");
        let cache = Shared.dataCache
        cache.fetch(key: "coresTitle").onSuccess { data in
            self.coreTitle = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            if (self.coreTitle.objectForKey("value") as? String) == (oneRowData["value"] as! String){
            
                cell!.downButton.setImage(UIImage(named:"select_bg"), forState: UIControlState.Normal)
                self.tableIndex = indexPath.section
            }
            
        }
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let laseIndex = NSIndexPath(forRow:0, inSection:tableIndex)
        let lastCell = tableView.cellForRowAtIndexPath(laseIndex) as! DiscoverTableViewCell
        lastCell.backgroundColor = UIColor(rgba:"#3F3F3F")
        lastCell.downButton.setImage(UIImage(named:"unselect_bg"), forState: UIControlState.Normal)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DiscoverTableViewCell
        let oneRowData = coresList[indexPath.section] as! NSDictionary
        coreTitle.setValue(oneRowData["name"], forKey:"name")
        coreTitle.setValue(oneRowData["value"] , forKey: "value")
        coreTitle.setValue(oneRowData["icon"] , forKey: "icon")
        Shared.dataCache.set(value:NSKeyedArchiver.archivedDataWithRootObject(coreTitle), key:"coresTitle")
        cell.downButton.setImage(UIImage(named:"select_bg"), forState: UIControlState.Normal)
        cell.backgroundColor = UIColor(rgba:"#1A1A1A")
        tableIndex = indexPath.section
        
        
    }
    
    
}
extension DiscoverViewController{

    
    private func getCoresData(){
         let cache = Shared.dataCache
        Alamofire.request(Router.Cores()).responseJSON{
            closureResponse in
            if closureResponse.result.isFailure {
             self.notice("网络异常", type: NoticeType.error, autoClear: true)
                cache.fetch(key: "coresList").onSuccess { data in
                self.coresList = NSMutableArray(array:NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSArray)
                self.tableView.reloadData()

                }
                return
            }
            let json = closureResponse.result.value
            self.coresList = json as! NSMutableArray
            if(self.coresList.count>0){
               
                setNativeData("coresList", MutableArray:self.coresList)
                
            }
            self.tableView.reloadData()
        }
    }
    
    func coreSelect(sender:UIButton){
    
        tableView(self.tableView, didSelectRowAtIndexPath:NSIndexPath(forRow:0, inSection:sender.tag))
    }
    
     func backAction(sender:UIButton){
         NSNotificationCenter.defaultCenter().postNotificationName("coreChange", object:coreTitle);
        self.dismissViewControllerAnimated(true, completion:nil)
        
    }

}