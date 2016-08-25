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

class VCRegistration: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var bg:UIImageView?
    @IBOutlet var uPhone:UITextField!
    @IBOutlet var uCountryCode:UIPickerView!
    
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
        /*
        if let path : String = NSBundle.mainBundle().pathForResource("countries", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                self.jCountries = JSON(data: data)
                
                //let jCountries = JSON(data: data)
                //print("json countries",jCountries)
                //print(jCountries.rawValue)
                print(self.jCountries.count)
                print(self.jCountries[0]["country"])
                
                self.pickerData.removeAll()
                print("===========================")
                for country in self.jCountries {
                    print(country.1["code"],country.1["country"])
                    let a:String = country.1["country"].string!
                    self.pickerData.append(a)
                }
                print("===========================")
            }
        }
        */
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