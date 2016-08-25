//
//  PIVDUtilContact.swift
//  hztb
//
//  Created by Pivotal on 8/25/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import Contacts
import SwiftyJSON
import Alamofire

class PIVDUtilContact {
    
    static var hasContactsFetched:Bool = false
    static var allContacts:Array = [CNContact]()
    //static var allPIVDContacts:Array = [PIVDContact]()
    
    class func getContacts(callerRef:VCRegistration){
        
        print("PIVDUtilContact : getContacts :")
        let appDelegate:AppDelegate = AppDelegate.getAppDelegate()
        appDelegate.requestForAccess { (accessGranted) in
            if accessGranted {
                self.onGotRequestGrant()
            }else{
                //appDelegate.showMessage("Not Granted!","Contact Access")
                callerRef.showAlertMessage("Not GRanted", "Contact Access")
            }
        }
        //let appDelegate:AppDelegate = AppDelegate.getAppDelegate()
        //appDelegate.showMessage("Not Granted!","Contact Access")
        //callerRef.showAlertMessage("Not GRanted", "Contact Access")
    }
    class func onGotRequestGrant(){
        print("PIVDUtilContact : onGotRequestGrant :")
        //MARK: Get the Contact store
        do{
            let contactStore:CNContactStore = AppDelegate.getAppDelegate().contactStore;
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNamePrefixKey, CNContactMiddleNameKey, CNContactPhoneNumbersKey]
            
            //reset the data
            PIVDUtilContact.allContacts = [CNContact]()
            //PIVDUtilContact.allPIVDContacts = [PIVDContact]()
            
            //print("Fetching all contacts. Now ============== ")
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch:keys)) { (contact, pointer) -> Void in
                //print(contact)
                //let s:String = String(contact)
                
                 print(contact.identifier,contact.givenName,contact.familyName,contact.phoneNumbers.count)
                 print ( (contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as! String)
                 print(" ==================== xxxxxxxxxx ================= ")
                 
                 print(" =========== xxx ============ ")
                 print ( (contact.phoneNumbers[0].value as! CNPhoneNumber) )
                 print ( (contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("countryCode") as! String)
                 print ( (contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as! String)
                 print(" =========== xxx ============ ")
                
                
                // MARK: Save the raw CNContact data
                
                allContacts.append(contact)
                /*
                // MARK: Parsing CNContact to PIVDContact
                // Parsing and storing for application
                var pivdContact:PIVDContact = PIVDContact()
                pivdContact.identifier = contact.identifier
                pivdContact.givenName = contact.givenName
                pivdContact.familyName = contact.familyName
                // taken the first phone number only
                pivdContact.phoneNumber_digits = (contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as! String
                pivdContact.countryCode = (contact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("countryCode") as! String
                // MARK: Saving all PIVDContact in local Array
                allPIVDContacts.append(pivdContact)
                */
                hasContactsFetched = true
            }
            //print("Fetching all contacts. Done ============= ")
            //callerRef.gotContacts()
            
            // Post the notification
            //let notification = NSNotification(name: "contact_fetch_success", object: self, userInfo:nil )
            let notification = NSNotification(name:AppStaticNames.CONTACT_FETCH_SUCCESS , object: self, userInfo:nil )
            NSNotificationCenter.defaultCenter().postNotification(notification)
            
            //var P = PIVDEventNames.contact_fetch_success
            
        }catch let error as NSError{
            print(error.description, separator: "", terminator: "\n")
        }
        
        //print("xxxxxxxxxxxxx")
        //print(self.allContacts)
    }
}