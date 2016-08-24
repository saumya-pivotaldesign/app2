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
    private var appVersion:String = "-1"
    private var buildNum:String = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onGotNotificationForInitCheckDone),
                                                         name: AppStaticNames.INIT_CHECK_DONE,
                                                         object: nil)
        //
        getVersionNumber()
        //initialCheck()
    }
}

extension VCAppEntry {
    private func getVersionNumber(){
        print("VCAppEntry:getVersionNumber:")
        //First get the nsObject by defining as an optional anyObject
        let nsObjectApp: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let nsObjectBuild: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObjectApp as! String
        let build = nsObjectBuild as! String
        //
        print("version",version)
        print("build",build)
        
        self.appVersion = version
        self.buildNum = build
        
        initialCheck()
    }
    private func initialCheck(){
        print("VCAppEntry:initialCheck:")
        //
        pivdUtil.initTheUtil()
        pivdUtil.initialCheck(self,vCode: self.buildNum,vName: self.appVersion)
    }
    internal func onDoneWithInitialCheck(){
        print("VCAppEntry:onDoneWithInitialCheck:")
        let notification = NSNotification(name: AppStaticNames.INIT_CHECK_DONE, object:self, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    internal func onGotNotificationForInitCheckDone(){
        print("VCAppEntry:onGotNotificationForInitCheckDone:")
        
        // Moved to Registration
        
        /*
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("sib_RegistrationViewController") as! VCRegistration
        self.presentViewController(next, animated: true, completion: nil)
        //self.showViewController(next, sender: self)
        */
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("sib_RegistrationViewController") as! VCRegistration
        let navigationController = UINavigationController(rootViewController: vc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}