//
//  VCOTPConf.swift
//  hztb
//
//  Created by Pivotal on 8/30/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class VCOTPConf: UIViewController {
    
    @IBOutlet var tOPT:UITextField!
    @IBOutlet var bConfirm:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VCOTPConf:viewDidLoad:")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("VCOTPConf:viewWillAppear:")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("VCOTPConf:viewDidAppear:")
    }
    
    @IBAction func onConfirmOTP(sender:AnyObject){
        print("VCOTPConf:onConfirmOTP:")
        validationOTP()
    }
    
}


extension VCOTPConf {
    private func validationOTP(){
        
        print("VCOTPConf : validationOTP : ")
        
        let sMobNum = AppDelegate.getAppDelegate().sRegisteredMobileNum
        
        let otpString:String = self.tOPT.text!
        print("VCOTPConf : validationOTP : otpString :",otpString," : sMobNum : ",sMobNum)
        
        
        let url = "http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/user/validateOTP"
        let headers = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":"en-US",
            "REQUEST_ID":"1212"
        ]
        let parameters = [
            "mobileNumber":"2222211111",
            "id":"1111111111111111",
            "otpCode": otpString
        ]
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                
                print("response",response)
                print("VCOTPConf : validationOTP : request=",response.request)
                print("VCOTPConf : validationOTP : response=",response.response)
                print("VCOTPConf : validationOTP : data=",response.data)
                print("VCOTPConf : validationOTP : result=",response.result)
        }
    }
}
