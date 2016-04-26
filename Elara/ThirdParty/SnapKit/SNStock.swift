//
//  SNStock.swift
//  Elara
//
//  Created by HeHongwe on 15/12/17.
//  Copyright © 2015年 harvey. All rights reserved.
//

import Foundation
import CoreBluetooth

class SNStock: NSObject, NSCoding
{
    let peripheral: CBPeripheral
   
    init(peripheral:CBPeripheral)
    {
        self.peripheral = peripheral
      
    }
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.peripheral = aDecoder.decodeObjectForKey("peripheral") as! CBPeripheral
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(peripheral, forKey: "peripheral")
        
    }
    
  
}