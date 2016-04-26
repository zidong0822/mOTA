//
//  AppDelegate.swift
//  Elara
//
//  Created by HeHongwe on 15/11/16.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit
import Haneke
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        MobClick.startWithAppkey("567d008767e58e69ac0002e6", reportPolicy:BATCH, channelId:"")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController =  ProjectViewController();
        
        reloadNativeData()

        
//        let started = NSUserDefaults.standardUserDefaults().valueForKey("started")
//        if started == nil {
//            let vc = GuideVC()
//            self.window?.rootViewController = vc
//            
//            vc.startClosure = {
//                () -> Void in
//                self.window?.rootViewController =  ProjectViewController();
//                
//                let userDefaults = NSUserDefaults.standardUserDefaults()
//                userDefaults.setValue("start", forKey: "started")
//                userDefaults.synchronize()
//            }
//        } else {
//            
//        }
//=======
//
//        let started = NSUserDefaults.standardUserDefaults().valueForKey("started")
//        if started == nil {
//            let vc = GuideVC()
//            self.window?.rootViewController = vc
//            
//            vc.startClosure = {
//                () -> Void in
//                self.window?.rootViewController =  ProjectViewController();
//                
//                let userDefaults = NSUserDefaults.standardUserDefaults()
//                userDefaults.setValue("start", forKey: "started")
//                userDefaults.synchronize()
//            }
//        } else {
//            self.window?.rootViewController =  ProjectViewController();
//        }
//>>>>>>> c2fd44d311c59894eca666198ab541d85756bb70
    
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
      
     }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
      
    }

    func reloadNativeData(){
    
        let icons = NSMutableDictionary()
        icons.setValue("\u{0000e90a}", forKey:"icon-c-usb-ttl")
        icons.setValue("\u{0000e90c}", forKey:"icon-c-usb-host")
        icons.setValue("\u{0000e90d}", forKey:"icon-c-wifi")
        icons.setValue("\u{0000e90e}", forKey:"icon-c-2dot4g")
        icons.setValue("\u{0000e90f}", forKey:"icon-c-zig-bee")
        icons.setValue("\u{0000e910}", forKey:"icon-c-nfc")
        icons.setValue("\u{0000e911}", forKey:"icon-c-wiz")
        icons.setValue("\u{0000e912}", forKey:"icon-c-enc")
        icons.setValue("\u{0000e913}", forKey:"icon-c-rs485")
        icons.setValue("\u{0000e915}", forKey:"icon-c-gsm-gprs")
        icons.setValue("\u{0000e916}", forKey:"icon-c-bluetouth")
        icons.setValue("\u{0000e917}", forKey:"icon-c-battery")
        icons.setValue("\u{0000e918}", forKey:"icon-c-gps")
        icons.setValue("\u{0000e919}", forKey:"icon-c-crash")
        icons.setValue("\u{0000e91a}", forKey:"icon-c-tft-screen")
        icons.setValue("\u{0000e91b}", forKey:"icon-c-oled-screen")
        icons.setValue("\u{0000e91c}", forKey:"icon-c-10dof")
        icons.setValue("\u{0000e91d}", forKey:"icon-c-rtc")
        icons.setValue("\u{0000e91e}", forKey:"icon-c-micro-sd")
        icons.setValue("\u{0000e91f}", forKey:"icon-c-amplifier")
        icons.setValue("\u{0000e920}", forKey:"icon-c-temperature")
        icons.setValue("\u{0000e921}", forKey:"icon-c-plush")
        icons.setValue("\u{0000e922}", forKey:"icon-c-lightness")
        icons.setValue("\u{0000e923}", forKey:"icon-c-motor")
        icons.setValue("\u{0000e924}", forKey:"icon-c-stepper")
        icons.setValue("\u{0000e925}", forKey:"icon-c-led")
        icons.setValue("\u{0000e926}", forKey:"icon-c-gray")
        icons.setValue("\u{0000e927}", forKey:"icon-c-ir-receiver")
        icons.setValue("\u{0000e928}", forKey:"icon-c-ir-sensor")
        icons.setValue("\u{0000e929}", forKey:"icon-c-pir")
        icons.setValue("\u{0000e908}", forKey:"icon-c-core")
        icons.setValue("\u{0000e909}", forKey:"icon-c-core-plus")
        icons.setValue("\u{0000e90b}", forKey:"icon-c-usb-core")
        icons.setValue("\u{0000e92a}", forKey:"icon-c-color-led")
        icons.setValue("\u{0000e904}", forKey:"icon-m-help")
        icons.setValue("\u{0000e809}", forKey:"icon-m-confirm")
        icons.setValue("\u{0000e930}", forKey:"icon-trush")

    
        let cache = Shared.dataCache
        cache.set(value:NSKeyedArchiver.archivedDataWithRootObject(icons), key:"icons")

        }


}

