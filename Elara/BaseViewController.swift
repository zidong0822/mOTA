//
//  BaseViewController.swift
//  Elara
//
//  Created by HeHongwe on 15/12/3.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgba:"#CDD4D3");
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"keyboardHide:");
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    
    func keyboardHide(tap:UITapGestureRecognizer){
       
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        
    }

}