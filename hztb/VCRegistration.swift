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

import AdSupport
import CoreLocation
import MapKit
import CoreTelephony

import SwiftyJSON
import Alamofire

class VCRegistration: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate {
    
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
    
    var locationManager: CLLocationManager!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VCRegistration : viewDidLoad :")
        
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
        
        //MARK: - Unique Identifier
        // ref : https://possiblemobile.com/2013/04/unique-identifiers/
        // IDFV
        let idIDFV = UIDevice.currentDevice().identifierForVendor?.UUIDString
        print("VCRegistration : viewDidLoad : idIDFV :",idIDFV)
        // Advertising ID
        //let idAdID = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        //print("VCRegistration : viewDidLoad : idAdID :",idAdID)
        AppDelegate.getAppDelegate().sUniqueRandomNum = idIDFV!
        
        //MARK: - Location
        // ref : https://stackoverflow.com/questions/25296691/swift-get-users-current-location-coordinates
        
        self.locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            //self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        //MARK:
        
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
        print("VCRegistration : callServerForRegistration : ")
        
        let num1:String = self.uPhone.text!
        let sPhone:String = AppDelegate.getAppDelegate().nCountryCode.stringValue+num1
        let sUnum:String = AppDelegate.getAppDelegate().sUniqueRandomNum
        
        print("VCRegistration : callServerForRegistration : sPhone",sPhone," : uniqueNum : ",sUnum)
        
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
            "id":sUnum
        ]
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                
                print("response",response)
                
                 print("VCRegistration : callServerForRegistration:post : request=",response.request)
                 print("VCRegistration : callServerForRegistration:post : response=",response.response)
                 print("VCRegistration : callServerForRegistration:post : data=",response.data)
                 print("VCRegistration : callServerForRegistration:post : result=",response.result)
                 
                 if let json1 = response.result.value {
                    print("VCRegistration:callServerForRegistration:json1: \(json1)")
                    // TODO: the whole of the below if-else should come here
                    
                 }else{
                    print("VCRegistration:callServerForRegistration:json1: FAIL :")
                    print(response)
                    self.showAlertMessage("TODO: Message","Fail")
                }
                
                //TODO: Once the query is cleared, uncomment these
                
                let jsonOBJ = JSON((response.result.value)!)
                
                // HTTP Status Code
                let sCode = (response.response)?.statusCode
                
                if(sCode==200){
                    //self.showAlertMessage("Done","Success")
                    print("===========================================")
                    print("VCRegistration : callServerForRegistration : post : jsonOBJ=",jsonOBJ)
                    print("VCRegistration : callServerForRegistration : post : jsonOBJ.isError =",jsonOBJ["isError"])
                    print("VCRegistration : callServerForRegistration : post : jsonOBJ.smsWaitTime =",jsonOBJ["smsWaitTime"])
                    print("VCRegistration : callServerForRegistration : post : jsonOBJ.otpWaitTime =",jsonOBJ["otpWaitTime"])
                    print("VCRegistration : callServerForRegistration : post : jsonOBJ.voiceWaitTime =",jsonOBJ["voiceWaitTime"])
                    print("===========================================")
                    if(jsonOBJ["isError"] == false){
                        //self.showAlertMessage("Done","Success")
                        
                        /*
                        let next = self.storyboard?.instantiateViewControllerWithIdentifier("sib_OTPConfVC") as! VCOTPConf
                        self.presentViewController(next, animated: true, completion: nil)
                        self.showViewController(next, sender: self)
                        */
                        
                        // saving values to store
                        AppDelegate.getAppDelegate().sRegisteredMobileNum = num1
                        //
                        AppDelegate.getAppDelegate().nSmsWaitTime = jsonOBJ["smsWaitTime"].numberValue
                        AppDelegate.getAppDelegate().nOtpWaitTime = jsonOBJ["otpWaitTime"].numberValue
                        AppDelegate.getAppDelegate().nVoiceWaitTime = jsonOBJ["voiceWaitTime"].numberValue
                        //
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("sib_OTPConfVC") as! VCOTPConf
                        //let navigationController = UINavigationController(rootViewController: vc)
                        //self.presentViewController(navigationController, animated: true, completion: nil)
                        self.navigationController!.pushViewController(vc, animated: true)
                        
                    }else{
                        self.showAlertMessage("Error","Success")
                    }
                }else if(sCode==400){
                    let msg:String = jsonOBJ["header"]["errors"][0]["message"].string!
                    //self.showAlertMessage("bad request","Error")
                    self.showAlertMessage(msg,"Error Information")
                }else{
                    self.showAlertMessage("request is unable to process at this time","Error")
                }
 
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
    
    //MARK: - Location Manager Update Location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.map.setRegion(region, animated: true)
        
        print("VCRegistration : locationManager:manager:didUpdateLocations : latitude : ",latitude," : longitude : ",longitude)
        
        //ref : https://stackoverflow.com/questions/24345296/swift-clgeocoder-reversegeocodelocation-completionhandler-closure
        
        let geocoder = CLGeocoder()
        
        print("-> Finding user address...")
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                
                print(placemark.ISOcountryCode,":",placemark.country,":",placemark.postalCode)
                
                /*
                var addressString : String = ""
                if placemark.ISOcountryCode == "TW" /*Address Format in Chinese*/ {
                    if placemark.country != nil {
                        addressString = placemark.country!
                    }
                    if placemark.subAdministrativeArea != nil {
                        addressString = addressString + placemark.subAdministrativeArea! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality!
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare!
                    }
                    if placemark.subThoroughfare != nil {
                        addressString = addressString + placemark.subThoroughfare!
                    }
                } else {
                    if placemark.subThoroughfare != nil {
                        addressString = placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    if placemark.administrativeArea != nil {
                        addressString = addressString + placemark.administrativeArea! + " "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                    }
                }
                
                print(addressString)
                */
                
            }
        })
        print("  =========")
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        print(networkInfo)
        print(networkInfo.subscriberCellularProvider)
        
        if (carrier != nil) {
            print("country code is: " + carrier!.mobileCountryCode!);
            //will return the actual country code
            print("ISO country code is: " + carrier!.isoCountryCode!);
        }else{
            print("No Carrier Found")
        }
        print("/ =========")
        //
    }

}