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
import SwiftyJSON

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
    
    
    internal func showAlertMessage(message:String, _ title:String="Note"){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            //
        }
        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}


extension VCOTPConf {
    private func validationOTP(){
        
        print("VCOTPConf : validationOTP : ")
        
        let sMobNum = AppDelegate.getAppDelegate().nCountryCode.stringValue+AppDelegate.getAppDelegate().sRegisteredMobileNum
        //AppDelegate.getAppDelegate().nCountryCode
        
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
            "mobileNumber":sMobNum,
            "id":"1111111111111111",
            "otpCode": otpString
        ]
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                
                print("================================================================")
                print("response",response)
                print("VCOTPConf : validationOTP : request=",response.request)
                print("VCOTPConf : validationOTP : response=",response.response)
                print("VCOTPConf : validationOTP : data=",response.data)
                print("VCOTPConf : validationOTP : result=",response.result)
                print(" / =============================================================")
                
                // HTTP Status Code
                let sCode = (response.response)?.statusCode
                print("========== sCode",sCode)
                
                if let json1 = response.result.value {
                    print("VCOTPConf: callServerForRegistration :json1: \(json1)")
                    
                    let jsonOBJ = JSON((response.result.value)!)
                    
                    if(sCode==200){
                        //self.showAlertMessage("Done","Success")
                        
                        //self.showAlertMessage("Done","Success")
                        print("===========================================")
                        print("VCRegistration:callServerForRegistration:post: jsonOBJ =",jsonOBJ)
                        print("VCRegistration:callServerForRegistration:post: jsonOBJ.isError =",jsonOBJ["isError"])
                        print("VCRegistration:callServerForRegistration:post: jsonOBJ.smsWaitTime =",jsonOBJ["smsWaitTime"])
                        print("VCRegistration:callServerForRegistration:post: jsonOBJ.otpWaitTime =",jsonOBJ["otpWaitTime"])
                        print("VCRegistration:callServerForRegistration:post: jsonOBJ.voiceWaitTime =",jsonOBJ["voiceWaitTime"])
                        print("===========================================")
                        if(jsonOBJ["isError"] == false){
                            self.showAlertMessage("Done","Success")
                            
                            //AppDelegate.getAppDelegate().sRegisteredMobileNum = num1
                            
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("sib_HomeViewController") as! VCHome
                            let navigationController = UINavigationController(rootViewController: vc)
                            self.presentViewController(navigationController, animated: true, completion: nil)
                            
                        }else{
                            //self.showAlertMessage("Error","Success")
                            let s = jsonOBJ["header"]["errors"][0]["message"].stringValue
                            self.showAlertMessage(s,"Info")
                        }
                        
                    }else if(sCode==400){
                        let msg:String = jsonOBJ["header"]["errors"][0]["message"].string!
                        //self.showAlertMessage("bad request","Error")
                        self.showAlertMessage(msg,"Error Information")
                    }else{
                        self.showAlertMessage("request is unable to process at this time","Error")
                    }
                
                }else{
                    print("VCOTPConf: callServerForRegistration :json1: FAIL :")
                    print(response)
                    self.showAlertMessage("TODO: Message","Fail")
                }
                
                
                
                
        }
    }
}
