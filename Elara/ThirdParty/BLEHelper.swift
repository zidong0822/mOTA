//
//  BLEHelper.swift
//  BLEHelper
//
//  Created by Microduino on 11/4/15.
//  Copyright © 2015 Microduino. All rights reserved.
//

import Foundation
import CoreBluetooth
//服务和特征的UUID
let kServiceUUID = [CBUUID(string:"F0C0")]
let kCharacteristicUUID = [CBUUID(string:"F0C1")]
let wCharacteristicUUID = [CBUUID(string:"F0C2")]
var periperel:NSString!

class BLEMingle: NSObject, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {


    var peripheralManager: CBPeripheralManager!
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var checkCharacteristic: CBCharacteristic!
    var restartCharacteristic:CBCharacteristic!
    var delegate: BLECentralDelegate?
    var dataToSend: NSData!
    var  count:Int = 1;
    
   
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("初始化蓝牙成功")
    }


    func startScan() {
        centralManager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey: false])
        print("开始搜索蓝牙设备")
    }
    
    func didDiscoverPeripheral(peripheral: CBPeripheral!) -> CBPeripheral! {
      
        return nil
    }
    func stopScan() {
        centralManager.stopScan()
        print("停止搜索")
    }
     //2.检查运行这个App的设备是不是支持BLE。代理方法
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.PoweredOn:
            print("蓝牙已打开,请扫描外设")
        case CBCentralManagerState.Unauthorized:
            print("这个应用程序是无权使用蓝牙低功耗")
        case CBCentralManagerState.PoweredOff:
            print("蓝牙目前已关闭")
        default:
            print("中央管理器没有改变状态")
        }

    }
    //3.查到外设后，停止扫描，连接设备
    //广播、扫描的响应数据保存在advertisementData 中，可以通过CBAdvertisementData 来访问它。
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber){
       
        print("搜索到设备：\(peripheral)")
        
        delegate?.didDiscoverPeripheral(peripheral)

    }
     //连接外设失败
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
    }
      //4.连接外设成功，开始发现服务
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
       
        print("连接到设备: \(peripheral)")
        
        self.performSelector("sendNotificationCenter", withObject:nil, afterDelay:3.0)

        //停止扫描外设
        self.centralManager.stopScan()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        self.peripheral.discoverServices(nil)
     
    }
    func sendNotificationCenter(){
    
        NSNotificationCenter.defaultCenter().postNotificationName("connectperipheral", object:nil)

    
    }
    //5.请求周边去寻找它的服务所列出的特征
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?){
        if error != nil {
            print("错误的服务特征:\(error!.localizedDescription)")
            return
        }
        var i: Int = 0
        for service in peripheral.services! {
            print("服务的UUID:\(service.UUID)")
            i++
            //发现给定格式的服务的特性
            if (service.UUID == CBUUID(string:"F0C0")) {
             
                peripheral.discoverCharacteristics(kCharacteristicUUID, forService: service as CBService)
                peripheral.discoverCharacteristics(wCharacteristicUUID, forService: service as CBService)
             
            }
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    //6.已搜索到Characteristics
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("发现特征的服务:\(service.UUID.data)   ==  服务UUID:\(service.UUID)")
        if (error != nil){
            print("发现错误的特征：\(error!.localizedDescription)")
            return
        }
        
        for  characteristic in service.characteristics!  {
            //罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
            print("服务UUID:\(service.UUID)         特征UUID:\(characteristic.UUID)")
            //特征的值被更新，用setNotifyValue:forCharacteristic
            switch characteristic.UUID.description {
            case "F0C1":

                self.peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
                self.checkCharacteristic = characteristic
                self.peripheral.setNotifyValue(true, forCharacteristic:characteristic);
           
            case "F0C2":
 
                self.peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
                self.writeCharacteristic = characteristic
                self.peripheral.setNotifyValue(true, forCharacteristic:characteristic);
                
            case "F0C3":
                self.peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
                self.restartCharacteristic = characteristic
            default:
                break
            }
        }

        print("didDiscoverCharacteristicsForService: \(service)")

    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
  
        if(characteristic.value?.length>0){
            
            
         delegate?.getMessageFromPeripheral(characteristic)
        }
              
    }
    //用于检测中心向外设写数据是否成功
       func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
         if(error != nil){
             print("发送数据失败!error信息:\(error)")
       }else{
              print("发送数据成功\(characteristic)")
         }
   }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {

        if error != nil {
                    print("更改通知状态错误：\(error?.localizedDescription)")
        }
    
         print("收到的特性数据：\(characteristic.value)")
       
                //如果它不是传输特性,退出.
         //        if characteristic.UUID.isEqual(kCharacteristicUUID) {
     //            return
   //        }
             //开始通知
                if characteristic.isNotifying {
                  print("开始的通知\(characteristic)")
             peripheral.readValueForCharacteristic(characteristic)
            }else{
          //通知已停止
          //所有外设断开
            print("通知\(characteristic)已停止设备断开连接")
                //  self.centralManager.cancelPeripheralConnection(self.peripheral)
         }
        
        print("==================\(characteristic.value)")
        
    }
    
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {

    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        
        
    }
    func retrievePeripheralsWithIdentifiers(identifiers: [NSUUID]!){
        
        let data = self.centralManager.retrievePeripheralsWithIdentifiers(identifiers)
        
        print("Data retrieved: \(data)")
        
        for peripheral1 in data as [CBPeripheral] {
            
            print("Peripheral : \(peripheral1)")
            delegate?.getNativePeripheral(peripheral1)
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        
        print("Central subscribed to characteristic: \(characteristic)")
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        
        print("Central unsubscribed from characteristic")
    }
    
    class var sharedInstance: BLEMingle {
        struct Static {
            static let instance: BLEMingle = BLEMingle()
        }
        return Static.instance
    }
    
    func checkValue(data: NSData!){
        if((peripheral) != nil){
            
            peripheral.writeValue(data, forCharacteristic: self.checkCharacteristic,type: CBCharacteristicWriteType.WithResponse)
           print("手机向蓝牙发送的数据为:\(data)")
           
        }
    }
    func writeValue(data: NSData!){
        if((peripheral) != nil){
            peripheral.writeValue(data, forCharacteristic: self.writeCharacteristic,type: CBCharacteristicWriteType.WithoutResponse)
            print("手机向蓝牙发送的数据为:\(data)")
        }
    }
    func restartValue(data: NSData!){
        if((peripheral) != nil){
            
            peripheral.writeValue(data, forCharacteristic: self.restartCharacteristic,type: CBCharacteristicWriteType.WithResponse)
            print("手机向蓝牙发送的数据为:\(data)")
            
        }
    }
    
    func connectPeripheral(peripheral: CBPeripheral){
    
        centralManager.connectPeripheral(peripheral, options: nil);
        
    }
    
    func cancalPeripheral(peripheral: CBPeripheral){
        
        centralManager.cancelPeripheralConnection(peripheral)
        
    }
    func connectPeripheralOfUUID(uuidString:String){
        
        
    }
}
protocol BLECentralDelegate {
    
    func didDiscoverPeripheral(peripheral: CBPeripheral!)
    
    func getMessageFromPeripheral(characteristic:CBCharacteristic!)
    
    func getNativePeripheral(peripheral:CBPeripheral)
    
}