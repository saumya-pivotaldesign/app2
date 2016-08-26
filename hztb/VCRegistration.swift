//
//  VCRegistration.swift
//  hztb
//
//  Created by Pivotal on 8/24/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import SwiftyJSON
import Alamofire

class VCRegistration: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var bg:UIImageView?
    
    //@IBOutlet var uCountryCode:UIPickerView!
    
    @IBOutlet var btnCountry:UIButton!
    @IBOutlet var lblCountryCode:UILabel!
    @IBOutlet var uPhone:UITextField!
    @IBOutlet var btnDone:UIBarButtonItem!
    
    var pickerData = ["United States","India","United Kingdom"]
    private var sCountryCode:String = "01"
    private var registrationResult:String = ""
    internal var sRegisteredNum:String = ""
    
    internal var jCountries:JSON!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VCRegistration:viewDidLoad:")
        
        //uCountryCode.dataSource = self
        //uCountryCode.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver( self,
                                                          selector:#selector(onGotContacts),
                                                          name: AppStaticNames.CONTACT_FETCH_SUCCESS , object: nil )
        NSNotificationCenter.defaultCenter().addObserver( self,
                                                          selector: #selector(addressBookDidChange),
                                                          name: CNContactStoreDidChangeNotification, object: nil)
        //
        //PIVDUtilContact.getContacts()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("VCRegistration : viewDidAppear : ")
        
        //PIVDUtilContact.getContacts(self)
        
        // If User has selected a Country, set the value here
        if(AppDelegate.getAppDelegate().sCountryName==""){
            //
        }else{
            btnCountry.setTitle(AppDelegate.getAppDelegate().sCountryName, forState: UIControlState.Normal)
            lblCountryCode.text = "+ " + AppDelegate.getAppDelegate().nCountryCode.stringValue
        }
    }
    
    @IBAction func onDone(sender:AnyObject){
        print("VCRegistration:onDone: ")
        let num1:String = self.uPhone.text!
        //print(self.lblCountryCode.text!+num1)
        let sFinal:String = AppDelegate.getAppDelegate().nCountryCode.stringValue+num1
        print(sFinal)
        callServerForRegistration()
    }
    
    private func callServerForRegistration(){
        print("VCRegistration:callServerForRegistration: ")
        
        let num1:String = self.uPhone.text!
        let sPhone:String = AppDelegate.getAppDelegate().nCountryCode.stringValue+num1
        
        // http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/app/initialcheck
        //let url = "http://hztb-dev.us-east-1.elasticbeanstalk.com/user/register" // old
        
        //let url = "http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/user/register"
        
        let url = "http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/user/requestcode"
        let headers = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":"en-US",
            "REQUEST_ID":"1"
        ]
        let parameters = [
            "mobileNumber":sPhone,
            "id":"1111111111111111"
        ]
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                
                
                 print("VCRegistration:callServerForRegistration:post : request=",response.request)
                 print("VCRegistration:callServerForRegistration:post : response=",response.response)
                 print("VCRegistration:callServerForRegistration:post : data=",response.data)
                 print("VCRegistration:callServerForRegistration:post : result=",response.result)
                 
                 if let json1 = response.result.value {
                    print("VCRegistration:callServerForRegistration:json1: \(json1)")
                    
                    
                 }else{
                    print("VCRegistration:callServerForRegistration:json1: FAIL :")
                    print(response)
                    self.showAlertMessage("TODO: Message","Fail")
                }
                
                //TODO: Once the query is cleared, uncomment these
                /*
                let jsonOBJ = JSON((response.result.value)!)
                
                print("===========================================")
                print("VCRegistration:callServerForRegistration:post: jsonOBJ=",jsonOBJ)
                print("VCRegistration:callServerForRegistration:post: jsonOBJ.status=",jsonOBJ["status"])
                print("VCRegistration:callServerForRegistration:post: jsonOBJ.isError=",jsonOBJ["isError"])
                print("VCRegistration:callServerForRegistration:post: jsonOBJ.needUpdate=",jsonOBJ["needUpdate"])
                print("VCRegistration:callServerForRegistration:post: jsonOBJ.header.status=",jsonOBJ["header"]["status"])
                print("VCRegistration:callServerForRegistration:post: jsonOBJ.header.requestId=",jsonOBJ["header"]["requestId"])
                print("===========================================")
                
                // HTTP Status Code
                let sCode = (response.response)?.statusCode
                print("sCode",sCode)
                
                if(sCode==200){
                    self.showAlertMessage("Done","Success")
                }else if(sCode==400){
                    let msg:String = jsonOBJ["header"]["errors"][0]["message"].string!
                    //self.showAlertMessage("bad request","Error")
                    self.showAlertMessage(msg,"Error Information")
                }else{
                    self.showAlertMessage("request is unable to process at this time","Error")
                }*/
 
        }
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

//MARK: Contacts API extension
extension VCRegistration {
    internal func gotContacts(){
        print("VCRegistrastion : gotContacts")
        
    }
    internal func onGotContacts(data:NSObject){
        print("VCRegistrastion : onGotContacts")
        
        /*
        let a = PIVDUtilContact.getAllContactNumbersAsStringArray()
        let b = Dictionary(dictionaryLiteral: ("userProfileRequests",a))
        let json = JSON(b)
        
        print("VCRegistrastion : onGotContacts : allAddress:")
        print(json)
        */
        
        // TODO: Redy to go for the server call
        print("VCRegistrastion : onGotContacts : TODO:Sync with server ")
    }
    
    internal func addressBookDidChange(){
        print("VCRegistrastion : addressBookDidChange")
        //PIVDUtilContact.getContacts()
    }
}

//MARK: - Delegates and data sources
extension VCRegistration {
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(pickerData[row])
        
        let s:String = pickerData[row] as String!
        var countryCode:String = "0"
        
        switch s {
        case "India":
            countryCode = "91"
        case "United Kingdom":
            countryCode = "44"
        default:
            countryCode = "01"
        }
        
        //print("CountryCode=",countryCode)
        self.sCountryCode = countryCode
    }
}