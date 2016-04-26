

import Foundation
import Alamofire
import Haneke

var fonticons = NSMutableDictionary()
var nativeData = NSMutableArray()
let fileManager = NSFileManager.defaultManager()
let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
var airports: Dictionary<String, String> = ["328p8m":"1","328p16m":"0","644pa16m":"2","644pa8m":"3","1284p16m":"4","1284p8m":"5","32u416m":"6","128rfa116m":"7"]
public  func getFontName(key:String)->String{

    let cache = Shared.dataCache
    cache.fetch(key: "icons").onSuccess { data in
        
        fonticons  = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
    }
  
    return fonticons.objectForKey("\(key)") as! String
}

public func getNativeSketche(key:String)->NSMutableArray{

    let cache = Shared.dataCache
    
   cache.fetch(key:key).onSuccess { data in

        nativeData = NSMutableArray(array:NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Array)
    }
    return NSMutableArray(array:nativeData)

}

public func setNativeData(key:String,MutableArray:NSMutableArray){
    
    let cache = Shared.dataCache
    
    cache.set(value:NSKeyedArchiver.archivedDataWithRootObject(MutableArray), key:key)
  
}

public func setPeripheralUUID(uuid:String){
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(uuid, forKey:"UUIDString")
    userDefaults.synchronize()

}
public func getPeripheralUUID()->String{

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if  userDefaults.objectForKey("UUIDString") != nil {
     
        return userDefaults.objectForKey("UUIDString") as! String
        
    }else{
    
        return ""
    
    }

}

public func sizeOfFile(fileUrl:NSString,CoreType:NSString)->NSData{

    let imageFile = NSData(contentsOfFile:fileUrl as String);
    let size = UInt32((imageFile?.length)!)
    
    let g_PartID = airports["\(CoreType)"]!;
    var requestData = [UInt8](count: 5, repeatedValue: 0);
    requestData[0] = UInt8(size & 0x000000ff);
    requestData[1] = UInt8((size & 0x0000ff00) >> 8);
    requestData[2] = UInt8((size & 0x00ff0000) >> 16);
    requestData[3] = UInt8((size & 0xff000000) >> 24);
    requestData[4] = UInt8(g_PartID)!;
    return NSData(bytes: requestData, length: requestData.count)

}




