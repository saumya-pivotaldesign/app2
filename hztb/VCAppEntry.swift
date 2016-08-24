//
//  VCAppEntry.swift
//  hztb
//
//  Created by Pivotal on 8/24/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import Realm


class VCAppEntry: UIViewController {
    
    private let pivdUtil:PIVDUtil = PIVDUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        getVersionNumber()
        //initialCheck()
    }
}

extension VCAppEntry {
    private func getVersionNumber(){
        print("VCAppEntry:getVersionNumber:")
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        print("version",version)
    }
    private func initialCheck(){
        print("VCAppEntry:initialCheck:")
        //
        pivdUtil.initTheUtil()
        pivdUtil.initialCheck(self)
    }
    internal func onDoneWithInitialCheck(){
        print("VCAppEntry:onDoneWithInitialCheck:")
    }
}