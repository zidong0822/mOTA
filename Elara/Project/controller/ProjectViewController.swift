//
//  Project1ViewController.swift
//  Elara
//
//  Created by HeHongwe on 15/12/1.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import CoreBluetooth
class ProjectViewController: BaseViewController{
    
    
    var backView:UIView?
    var picker:CZPickerView!
    var bleMingle: BLEMingle!
    var successButton:UIButton!
    var tableView : ExtensibleTableView?
    var nativeTableView:ExtensibleTableView?
    var currentIndexPath:NSIndexPath!
    var peripheral: CBPeripheral!
    var peripheralString:String = ""
    var _nBytes:Int = 0
    var writeCount:Int = 16
    var timer:NSTimer!
    var baseCount:Int = 8
    var fileUrl:NSString = ""
    var downLoadFileList = NSMutableArray()
    var deviceList = NSMutableArray()
    var sketches = NSMutableArray()
    var nativeSketches = NSMutableArray()
    var downLoadCount:Int = 0
    var nowTableTag:Int = 0
    var brushTag:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init bleMingle
        bleMingle = BLEMingle()
        bleMingle.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "coreChange:", name: "coreChange", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectperipheral:", name: "connectperipheral", object: nil)
        prepareUI()
        
        }

    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        
        layoutUI()
        let workingQueue = dispatch_queue_create("my_queue", nil)
        dispatch_async(workingQueue) {
            NSThread.sleepForTimeInterval(2)
            dispatch_async(dispatch_get_main_queue()) {
        self.prepareData()
       
            }
        }
        
    }
    
    private func prepareUI() {
  
        self.view.backgroundColor = UIColor(rgba:"#CDD4D3")
        createTable()
        view.addSubview(navigationView)
        view.addSubview(downLoadButton)
        view.addSubview(searchBar)
        
    }
    /**
     约束子控件的方法
     */
    private func layoutUI() {
    
        downLoadButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-25)
            make.bottom.equalTo(-40)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        searchBar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(70)
            make.width.equalTo(SCREEN_WIDTH-20)
            make.height.equalTo(40)
        }
        navigationView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(64)
        }
    }
    /// downLoadButton 悬浮按钮
    lazy var downLoadButton: DownLoadButton = {
        let downLoadButton = DownLoadButton()
        downLoadButton.setImage(UIImage(named:"icon_download_green"), forState: UIControlState.Normal)
        downLoadButton.addTarget(self, action:"goDownList:", forControlEvents: UIControlEvents.TouchUpInside)
        return downLoadButton
    }()
 
    
    /// searchBar 搜索框
    lazy var searchBar:SearchBar = {
        let searchBar = SearchBar()
        searchBar.delegate = self
        return searchBar
    
    }()
    
    lazy var navigationView:NavigationView = {
        let navigationView = NavigationView()
        let cache = Shared.dataCache
        cache.fetch(key: "coresTitle").onSuccess { data in
            let coreTitle = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            navigationView.titleLabel.text = coreTitle.objectForKey("name") as? String
            navigationView.logoButton.backgroundColor = UIColor(rgba:"#AEE519")
            navigationView.nameLabel.text = coreTitle.objectForKey("value") as? String
            navigationView.helpLabel.hidden = true
            navigationView.logoButton.setTitle(getFontName(coreTitle.objectForKey("icon") as! String), forState: UIControlState.Normal)
        }
        navigationView.delegate = self
        return navigationView
    
    }()
   
    // MARK: init UI
    func createPickerView(){
        
        picker = CZPickerView(headerTitle:"Devices",cancelButtonTitle:TITLE_CANCEL,confirmButtonTitle:TITLE_OK)
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = false;
        self.picker.show()
    }
    
    func createTable(){
        
        backView = UIView(frame:CGRectMake(10,110,UIScreen.screenWidth()-20,UIScreen.screenHeight()-90))
        backView?.backgroundColor = UIColor(rgba:"#CDD4D3")
        view.addSubview(backView!)
        
        self.nativeTableView = ExtensibleTableView(frame:CGRectMake(0,0,UIScreen.screenWidth()-20,UIScreen.screenHeight()-110), style:UITableViewStyle.Grouped)
        self.nativeTableView?.backgroundColor = UIColor(rgba:"#CDD4D3")
        self.nativeTableView?.dataSource = self
        self.nativeTableView!.delegate = self
        self.nativeTableView?.tag = 101
        self.nativeTableView?.tableFooterView = UIView();
        self.nativeTableView!.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.nativeTableView!.registerClass(ProjcetTableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        backView!.addSubview(self.nativeTableView!)
        self.setSeparatorInsetZeroWithTableView(self.nativeTableView)
        
        
        self.tableView = ExtensibleTableView(frame:CGRectMake(0,0,UIScreen.screenWidth()-20,UIScreen.screenHeight()-110), style:UITableViewStyle.Grouped)
        self.tableView?.backgroundColor = UIColor(rgba:"#CDD4D3")
        self.tableView?.dataSource = self
        self.tableView!.delegate = self
        self.tableView?.tableFooterView = UIView();
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.tableView?.tag = 100
        backView!.addSubview(self.tableView!)
        self.tableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:"tableFooterRefresh")
        self.setSeparatorInsetZeroWithTableView(self.tableView)
        
        getNativeFile()
    
     }
    
    
    private func prepareData(){
    
        CozyLoadingActivity.show("loading...", disableUI: true)
      
        if getPeripheralUUID().characters.count>0{
        
            peripheralString = getPeripheralUUID()
          //  bleMingle.retrievePeripheralsWithIdentifiers([NSUUID(UUIDString:peripheralString)!])
     
        }
        initNativeData()
        if((self.navigationView.nameLabel.text) != nil){
            
            self.getSketchesData(0, limit:self.baseCount, core:self.navigationView.nameLabel.text!)
        }else{
            self.getSketchesData(0, limit:self.baseCount, core:"all")
        }
    }
   
}
// MARK: - UITableViewDataSource, UITableViewDelegate 数据源和代理方法
extension ProjectViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView.tag == 100){
            return sketches.count
        }else{
            
            return checknativeSketches()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#CDD4D3")
        return view
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#CDD4D3")
        return view
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let tableCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        tableCell.selectionStyle = UITableViewCellSelectionStyle.None
        var oneRowData = NSDictionary()
        let projcetTableViewCell = ProjcetTableViewCell()
        if(tableView.tag == 100){
            if(self.tableView!.isEqualToSelectedIndexPath(indexPath))
            {
                currentIndexPath = indexPath
                return self.tableView(tableView, extendedCellForRowAtIndexPath:indexPath)
            }
        
        }else{
            if(self.nativeTableView!.isEqualToSelectedIndexPath(indexPath))
            {
                currentIndexPath = indexPath
                return self.tableView(tableView, extendedCellForRowAtIndexPath:indexPath)
            }
        }
       
        if(tableView.tag == 100){
            oneRowData = sketches[indexPath.section] as! NSDictionary
        }else{
            oneRowData = nativeSketches[indexPath.section] as! NSDictionary
            
        }
       projcetTableViewCell.ProjectTableCell(tableCell, indexPath:indexPath, cellData:oneRowData)
        if(isDownLoad((oneRowData["_id"]as? String)!)){
            if(tableView.tag == 100){
                projcetTableViewCell.downButton.setTitle(getFontName("icon-m-confirm"), forState: UIControlState.Normal)
                projcetTableViewCell.downButton.setTitleColor(UIColor(rgba:"#B4F91D"), forState: UIControlState.Normal)
                projcetTableViewCell.downButton.titleLabel?.font = UIFont(name:"microduino-icon", size:30)
            }else{
                projcetTableViewCell.downButton.setTitle(getFontName("icon-trush"), forState: UIControlState.Normal)
                projcetTableViewCell.downButton.setTitleColor(UIColor(rgba:"#B4F91D"), forState: UIControlState.Normal)
                projcetTableViewCell.downButton.titleLabel?.font = UIFont(name:"icomoon", size:15)
                projcetTableViewCell.downButton.addTarget(self, action:"deleteFile:", forControlEvents: UIControlEvents.TouchUpInside)
            }
          
            
        }else{
            projcetTableViewCell.downButton.setImage(UIImage(named:"icon_download_green"), forState:UIControlState.Normal)
            projcetTableViewCell.downButton.addTarget(self, action:"addDownCount:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        projcetTableViewCell.downButton.tag = indexPath.section
        return tableCell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var oneRowData = NSDictionary()
        if((navigationView.nameLabel.text) != nil){
            if(tableView.tag == 100){
                oneRowData = sketches[indexPath.section] as! NSDictionary
                fileUrl = "\(directoryURL.path! as String)/\(oneRowData["_id"] as! String)-\(navigationView.nameLabel.text! as String).bin"
                print(fileIsExist(oneRowData["_id"]as! String))
                if(self.tableView!.isEqualToSelectedIndexPath(indexPath)){
                    self.tableView!.shrinkCellWithAnimated(true)
                }
                else{
                    self.tableView!.extendCellAtIndexPath(indexPath, animated:true, goToTop:false)
                }
                
                
            }else{
                oneRowData = nativeSketches[indexPath.section] as! NSDictionary
                fileUrl = "\(directoryURL.path! as String)/\(oneRowData["_id"] as! String)-\(navigationView.nameLabel.text! as String).bin"
                if(self.nativeTableView!.isEqualToSelectedIndexPath(indexPath)){
                    
                    self.nativeTableView!.shrinkCellWithAnimated(true)
                }
                else{
                    
                    self.nativeTableView!.extendCellAtIndexPath(indexPath, animated:true, goToTop:false)
                }
            }

        
        }else{
            self.presentViewController(DiscoverViewController(), animated:true, completion: { () -> Void in
                
            })

        
        }
           }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

         if(tableView.tag == 101){
            
            let oneRowData  = self.nativeSketches[indexPath.section] as! NSDictionary
            self.deleteFileAction(oneRowData["_id"] as! String)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        if(tableView.tag==101){
        
            return true
        }else{
        
             return false
        
        }
    }
    
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        UIView.animateWithDuration(0.25, animations: {
//            cell.layer.transform = CATransform3DMakeTranslation(1, 1, 1)
//        })
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(tableView.tag == 100){
            if(self.tableView!.isEqualToSelectedIndexPath(indexPath)){
                
                return  self.tableView(tableView, extendedHeightForRowAtIndexPath:indexPath)
                
            }
        }else{
            if(self.nativeTableView!.isEqualToSelectedIndexPath(indexPath)){
                
            return  self.tableView(tableView, extendedHeightForRowAtIndexPath:indexPath)
                
            }
        }
        
        return 120;
    }
}
// MARK:view上的一些事件处理在这个类扩展里
extension ProjectViewController {
    
    private func getSketchesData(offest:Int,limit:Int,core:String){
        let cache = Shared.dataCache
        Alamofire.request(Router.Sketches(offset:offest, limit:limit,core:core)).responseJSON{
            closureResponse in
            if closureResponse.result.isFailure {
                 CozyLoadingActivity.hide(success: false, animated:true)
                self.notice("网络异常", type: NoticeType.error, autoClear: true)
                cache.fetch(key: "sketches").onSuccess { data in
                    self.sketches =  NSMutableArray(array:NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSArray)
                    self.getNativeSketches()
                    self.tableView?.reloadData()
                    
                }
                
            }else{
            let json = closureResponse.result.value
                self.sketches = json as! NSMutableArray
                self.getNativeSketches()
            setNativeData("sketches", MutableArray:self.sketches)
            CozyLoadingActivity.hide(success: true, animated:true)
            self.tableView!.reloadData()
            }
            
            
        }
    }
    
    private func downloadFile(modelId:String,coreValue:String,tag:Int){
        if(tag == 0){
        CozyLoadingActivity.show("download...", disableUI: true)
        }
        let downloadfileURL  = "\(ServiceApi.host)/api/v1.0/sketches/\(modelId)/download/\(coreValue)"
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain:.UserDomainMask)
        
        Alamofire.download(.GET,downloadfileURL, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                dispatch_async(dispatch_get_main_queue()) {
                    
                }
            }
            .response { _, _, _, error in
                if(tag == 0){
                if let error = error {
                
                    if(error.code == 516){
                        YHAlertController.alert("", message: "文件已下载", acceptMessage: "确定") { () -> () in
                        }
                    }
                    print("Failed with error: \(error)")
                    CozyLoadingActivity.hide(success: false, animated:true)
                    
                } else {
                    print("Downloaded file successfully")
                    CozyLoadingActivity.hide(success: true, animated:true)
                    self.getNativeFile()
                    
                }
                }else{
                    
                    self.getNativeFile()
                
                }
        }
        
    }
    // MARK: - getNativeFile
   private func getNativeFile(){
        
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            
            let MusicLists = try
            NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryURL.path!)
            downLoadFileList = NSMutableArray(array:MusicLists)
            self.tableView?.reloadData()
            self.nativeTableView?.reloadData()
        } catch {
            
        }
    }

    private func getNativeSketches(){
    
    if((navigationView.nameLabel.text) != nil){
        nativeSketches = NSMutableArray()
        for oneFileData in sketches{
        let filename = "\(oneFileData["_id"] as! String)-\(navigationView.nameLabel.text!).bin"
            for nativefilename in downLoadFileList{
            
                if(filename == nativefilename as! String){
                
                    nativeSketches.addObject(oneFileData)
                }}
        }
        self.tableView?.reloadData()
        self.nativeTableView?.reloadData()
        

        
        }
    }
    private  func initNativeData(){
    
        // getNativeSketches
        let cache = Shared.dataCache
        cache.fetch(key:"nativesketches").onSuccess { data in
            self.nativeSketches =  NSMutableArray(array:NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSArray)
        }
        
    }
    
   private func checknativeSketches()->Int{
    
        for name in nativeSketches
        {
            if((navigationView.nameLabel.text) != nil){
                let filename  = "\(name.objectForKey("_id")!)-\(navigationView.nameLabel.text!).bin"
                if !downLoadFileList.containsObject(filename as String){
                    
                    nativeSketches.removeObject(name)
                }
              
            }
        }
        return nativeSketches.count
    
    
    }
    func coreChange(title:NSNotification){
        
        brushTag = 0
        let coreTitle = title.object as! NSDictionary
       
        if (coreTitle.objectForKey("value") != nil){
           
            getSketchesData(0,limit:self.baseCount, core:(coreTitle.objectForKey("value") as? String)!)
        }
    }
    
    func isDownLoad(var filename:String)->Bool{
    
        if(navigationView.nameLabel.text==nil){
        
            return false
        
        }else{
            filename = "\(filename)-\(navigationView.nameLabel.text!).bin"
            
            for downfilename in downLoadFileList{
                
                if(filename == downfilename as! String){
                    
                    return true
                }
            }
            return false
        
        }
    }
    
    func addDownCount(sender:UIButton){

        var oneRowData = NSDictionary()
        if(nowTableTag == 0){
            oneRowData = sketches[sender.tag] as! NSDictionary
        }else{
            
            oneRowData = nativeSketches[sender.tag] as! NSDictionary
        }
        if(navigationView.nameLabel.text != nil){
        
            downloadFile((oneRowData["_id"] as? String)!, coreValue:navigationView.nameLabel.text!,tag:0)
            
        
        }else{
        
            
            self.presentViewControllerLikePushAnimation(DiscoverViewController())
        }

        }
    
    func deleteFile(sender:UIButton){

        if(nowTableTag == 1){
            
            YHAlertController.alert("提示", message: "是否删除？", buttons: ["取消", "确认"]) { (alertAction, position) -> Void in
                if position == 1 {
                    let oneRowData  = self.nativeSketches[sender.tag] as! NSDictionary
                    self.deleteFileAction(oneRowData["_id"] as! String)
                }
            }
        }
 }
    func goDownList(sender:UIButton){
        
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView:backView!, cache:true)
        let fist = ((backView!.subviews).indexOf(backView!.viewWithTag(100)!))
        let second = ((backView!.subviews).indexOf(backView!.viewWithTag(101)!))
        if(fist == 0){
            self.nativeTableView?.hidden = true
            downLoadButton.setImage(UIImage(named:"icon_download_green"), forState: UIControlState.Normal)
            self.tableView?.reloadData()
        }else{
            self.nativeTableView?.hidden = false
            getNativeSketches()
            downLoadButton.setImage(UIImage(named:"icon_discover_green"), forState: UIControlState.Normal)
            self.nativeTableView?.reloadData()
        }
        backView!.exchangeSubviewAtIndex(fist!, withSubviewAtIndex: second!)
        UIView.setAnimationDelegate(self)
        UIView.commitAnimations()
        nowTableTag = fist!
       

    }
    
    func tableFooterRefresh(){
    
        let workingQueue = dispatch_queue_create("my_queue", nil)
        dispatch_async(workingQueue) {
            dispatch_async(dispatch_get_main_queue()) {
                if((self.navigationView.nameLabel.text) != nil){
                    self.getSketchesData(0, limit:self.baseCount+8, core:self.navigationView.nameLabel.text!)
                    self.baseCount = self.baseCount+8
                
                }else{
                    self.getSketchesData(0, limit:self.baseCount+8, core:"all")
                    self.baseCount = self.baseCount+8
                   }
               
                self.tableView?.reloadData()
                self.tableView?.mj_footer.endRefreshing()
            }
        }
    }
    
   
     // MARK: - scanBlueTooth
    func scanBlueTooth(sender:UIButton){

        CozyLoadingActivity.show("searching...", disableUI: true)
        bleMingle.startScan()
        self.performSelector("checkBleState", withObject:nil, afterDelay:30.0)

    }
    
    // MARK: - initbleMingle
    func initbleMingle(){
        _nBytes = 0
        bleMingle.cancalPeripheral(peripheral)
        peripheral = nil
        self.deviceList.removeAllObjects()
        bleMingle = BLEMingle()
        bleMingle.delegate = self
    }
    
    // MARK: - connectperipheralNSNotification
    func connectperipheral(title:NSNotification){
        
        if(brushTag == 1){

        CozyLoadingActivity.hide(success: true, animated:true)

        self.performSelector("brush", withObject:nil, afterDelay:1.5)


        
        }
        
    }
    // MARK: - checkBleState
    func checkBleState(){
        
        if((peripheral) == nil){
            CozyLoadingActivity.showWithDelay("search timeout", disableUI:true, seconds:3)
        }
    
    }
    func brush(){
    
        CozyLoadingActivity.show("upload...", disableUI: true)

        self.performSelector("writeData:", withObject:nil, afterDelay:2.0)

    }
    // MARK: - brushBin  开始刷机
    func brushBin(sender:UIButton){
        successButton = sender
        var oneRowData = NSDictionary()
        if(nowTableTag == 0){
            oneRowData = sketches[sender.tag] as! NSDictionary
        }else{
            oneRowData = nativeSketches[sender.tag] as! NSDictionary
        }
        if(navigationView.nameLabel.text != nil){
                
            downloadFile((oneRowData["_id"] as? String)!, coreValue:navigationView.nameLabel.text!,tag:1)
        }else{
            self.presentViewController(DiscoverViewController(), animated: true) { () -> Void in
                    
        }}
        
        if((peripheral) != nil){
            bleMingle.connectPeripheral(peripheral);
            brushTag = 1
            CozyLoadingActivity.show("connecting...", disableUI: true)
        }else if(!peripheralString.isEmpty){
            if getPeripheralUUID().characters.count>0{
                peripheralString = getPeripheralUUID()
                bleMingle.retrievePeripheralsWithIdentifiers([NSUUID(UUIDString:peripheralString)!])
                brushTag = 1
                CozyLoadingActivity.show("connecting...", disableUI: true)
            }
        }
    }
    
    // MARK: - write data to hardWare
    
    func writeData(sender:UIButton){
  

        let imageFile = NSData(contentsOfFile:fileUrl as String);
        let size = UInt32((imageFile?.length)!)
        
        let g_PartID = airports["\(navigationView.nameLabel.text!)"]!;
        
        var requestData = [UInt8](count: 5, repeatedValue: 0);
        requestData[0] = UInt8(size & 0x000000ff);
        requestData[1] = UInt8((size & 0x0000ff00) >> 8);
        requestData[2] = UInt8((size & 0x00ff0000) >> 16);
        requestData[3] = UInt8((size & 0xff000000) >> 24);
        requestData[4] = UInt8(g_PartID)!;
        
        let data = NSData(bytes: requestData, length: requestData.count)
        bleMingle.checkValue(data);

        
    }
    func doTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.020, target: self, selector: "timerFireMethod", userInfo: nil, repeats:true);
        timer.fire()
        
    }
    
    func timerFireMethod() {
        
        let imageFile = NSData(contentsOfFile:fileUrl as String);
        if (_nBytes+writeCount<imageFile!.length) {
            
            bleMingle.writeValue(imageFile?.subdataWithRange(NSMakeRange(_nBytes,writeCount)))
        }
        else{
            
            let  data  = imageFile?.subdataWithRange(NSMakeRange(_nBytes, (imageFile?.length)!-_nBytes))
            let string: NSString = "1111111111111111"
            let data1 = string.dataUsingEncoding(NSUTF8StringEncoding)
            let data2 = data1?.subdataWithRange(NSMakeRange(0,writeCount-((imageFile?.length)!-_nBytes)))
            let data3:NSMutableData = NSMutableData(data: data!)
            data3.appendData(data2!)
            bleMingle.writeValue(data3)
            timer.fireDate = NSDate.distantFuture();
            CozyLoadingActivity.hide(success: true, animated: true)
        }
        _nBytes=_nBytes+writeCount
    }
    
    
    // MARK: - isCouldBrush
    
    func isCouldBrush(sender:Int)->Bool{
      
        var oneRowData = NSDictionary()
        if(nowTableTag == 0){
            oneRowData = sketches[sender] as! NSDictionary
        }else{
            oneRowData = nativeSketches[sender] as! NSDictionary
        }
        if (navigationView.nameLabel.text != nil){
            
            return fileIsExist(oneRowData["_id"] as! String)
            
        }else{
        
            return false
        }
       }
    
    
    // MARK: - fileIsExist
    
    func fileIsExist(fileId:String)->Bool{
    
        fileUrl = "\(directoryURL.path! as String)/\(fileId)-\(navigationView.nameLabel.text! as String).bin"
        if NSFileManager.defaultManager().fileExistsAtPath(fileUrl as String){
            return true
        }else{
            
            return false
        }
    }
    
     // MARK: - delele File base of ID
    
    func deleteFileAction(fileId:String){
    
        self.fileUrl = "\(directoryURL.path! as String)/\(fileId)-\(self.navigationView.nameLabel.text! as String).bin"
        do {
            try  NSFileManager.defaultManager().removeItemAtPath(self.fileUrl as String)
        } catch {
            
        }
        self.nativeSketches.removeObject(fileId)
        setNativeData("nativesketches", MutableArray:self.nativeSketches)
        self.initNativeData()
        self.getNativeFile()
        self.getNativeSketches()
        }

        
    
    
}
    
    
    

// MARK: - UItableviewSpread
extension ProjectViewController:ExtensibleTableViewDelegate{
    
    func tableView(tableView: UITableView!, extendedCellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let tableCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        tableCell.selectionStyle = UITableViewCellSelectionStyle.None
        let projectSpreadCell = ProjectSpreadCell()
        var oneRowData = NSDictionary()
        if(tableView.tag == 100){
            oneRowData = sketches[indexPath.section] as! NSDictionary
        }else{
            oneRowData = nativeSketches[indexPath.section] as! NSDictionary
        }
        if((peripheral) != nil){
            projectSpreadCell.ProjectSpreadCell(tableCell, indexPath:indexPath, cellData:oneRowData,isConnect:true)
            projectSpreadCell.discoverButton.setTitle(peripheral.identifier.UUIDString, forState:UIControlState.Normal)
        }else{
            if(!peripheralString.isEmpty){
                projectSpreadCell.ProjectSpreadCell(tableCell, indexPath:indexPath, cellData:oneRowData,isConnect:true)
                projectSpreadCell.discoverButton.setTitle(peripheralString, forState:UIControlState.Normal)
            }else{
                projectSpreadCell.ProjectSpreadCell(tableCell, indexPath:indexPath, cellData:oneRowData, isConnect:false)
            }
            
        }
        if(isDownLoad((oneRowData["_id"]as? String)!)){
     
            projectSpreadCell.downButton.setTitle(getFontName("icon-m-confirm"), forState: UIControlState.Normal)
            projectSpreadCell.downButton.setTitleColor(UIColor(rgba:"#B4F91D"), forState: UIControlState.Normal)
            projectSpreadCell.downButton.titleLabel?.font = UIFont(name:"microduino-icon", size:30)
            projectSpreadCell.downButton.addTarget(self, action:"deleteFile:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }else{
           projectSpreadCell.downButton.setImage(UIImage(named:"icon_download_green"), forState:UIControlState.Normal)
            projectSpreadCell.downButton.addTarget(self, action:"addDownCount:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        projectSpreadCell.downButton.tag = indexPath.section
        projectSpreadCell.discoverButton.addTarget(self, action:"scanBlueTooth:", forControlEvents:UIControlEvents.TouchUpInside)
        projectSpreadCell.bushButton.addTarget(self, action:"brushBin:", forControlEvents:UIControlEvents.TouchUpInside)
        projectSpreadCell.bushButton.tag = indexPath.section
        projectSpreadCell.discoverButton.tag = indexPath.section

        return tableCell;
        
    }
   
    func tableView(tableView:UITableView!, extendedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 240
    }
}
// MARK: - navigationViewDelegate mathod
extension ProjectViewController:navigationViewDelegate{

    func navigationViewAction(tap:UITapGestureRecognizer){
      
       self.presentViewController(DiscoverViewController(), animated: true) { () -> Void in
            
        }
    }
}
// MARK: - UISearchBarDelegate mathod
extension ProjectViewController:UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        Alamofire.request(Router.Search(station:searchText)).responseJSON{
        
            closureResponse in
            if(closureResponse.result.isFailure){
            
            self.notice("网络异常", type: NoticeType.error, autoClear: true)
            }else{
                    let json = closureResponse.result.value
                
                    self.sketches = NSMutableArray(array:json as! Array)
                    self.tableView?.reloadData()
                }
        }
    }
    
}

extension ProjectViewController:BLECentralDelegate{

    // MARK: - DiscoverPeripheral
    func didDiscoverPeripheral(peripheral: CBPeripheral!){
        
        if((peripheral.name) != nil){
            if(peripheral.name!.containsString("Elara")){
                CozyLoadingActivity.hide(success: true, animated: true)
                if(self.deviceList.count<1){
                    self.deviceList.addObject(peripheral)
                    setPeripheralUUID(peripheral.identifier.UUIDString)
                }  
                if((picker) != nil){
                    picker.removeFromSuperview()
                    createPickerView()
                }else{
                    createPickerView()
                }
            }
        
        }
        
    }
    func getNativePeripheral(peripheral: CBPeripheral) {
       
        self.peripheral = peripheral
        bleMingle.connectPeripheral(peripheral)
    }
    func getMessageFromPeripheral(characteristic: CBCharacteristic!) {
        
        switch characteristic.UUID.UUIDString{
        case "F0C1":
            var src: UInt32 = 0xffffffff
            var out: UInt32 = 0
            var out1:UInt32 = 0;
            let data = NSData(bytes: &src, length: sizeof(UInt32))
            let data1 = characteristic.value
            data.getBytes(&out, length: sizeof(UInt32))
            data1?.getBytes(&out1,length: sizeof(UInt32));
            if(out1==0){
                YHAlertController.alert("Wrong Size!", message:"The bin size is too big!", acceptMessage: "cancel") { () -> () in
                }
            }else if(out1==out){
                self.performSelector("doTimer", withObject:nil, afterDelay:9.0)
                
            }else{
                self.performSelector("doTimer", withObject:nil, afterDelay:6.0)
            }
        case "F0C2":
            successButton.setTitle("successed!", forState:UIControlState.Normal)
            successButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            successButton.backgroundColor = UIColor(rgba:"#AEE519")
            self.performSelector("initbleMingle", withObject:nil, afterDelay:6.0)

        default:break;
        }
        
    }
}
extension ProjectViewController:CZPickerViewDataSource,CZPickerViewDelegate{


    // MARK: - pick view data source
    func czpickerView(pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        
        let TitleAttribute : NSDictionary =   NSDictionary(object:UI_FONT_13!, forKey:NSFontAttributeName)
        let cpl = self.deviceList[row] as!CBPeripheral
        let att =  NSAttributedString(string:cpl.identifier.UUIDString, attributes:TitleAttribute as? [String : AnyObject])
        return att;
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
      
        peripheral  = self.deviceList[row] as!CBPeripheral
        reloadOneRowData()
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        
        return self.deviceList.count
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return self.deviceList[row] as! String
    }
    
    func reloadOneRowData(){
    
        if(nowTableTag == 0){
            
            self.tableView?.reloadData()
        }else{
            
            self.nativeTableView?.reloadData()

        }
    }
    
}
