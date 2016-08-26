//
//  VCCountrySelection.swift
//  hztb
//
//  Created by Pivotal on 8/25/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class VCCountrySelection: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    internal var jCountries:JSON!
    //internal var pickerData:Array<String>!
    var pickerData: [JSON] = []
    
    @IBOutlet var tableViewCountries:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        tableViewCountries.delegate=self
        tableViewCountries.dataSource=self
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
        // ==========================================
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
                    //print(country.1["code"],country.1["country"])
                    //let a:String = country.1["country"].string!
                    //self.pickerData.append(a)
                    self.pickerData.append(country.1)
                }
                print(pickerData)
                print("===========================")
                
                self.tableViewCountries.reloadData()
            }
        }
        // ==========================================
    }
}

extension VCCountrySelection {
    //MARK: TableView delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("VCCountrySelection : tableView:numberOfRowsInSection: self.pickerData.count",self.pickerData.count)
        return self.pickerData.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("VCCountrySelection : tableView:cellForRowAtIndexPath: indexPath.row",indexPath.row)
        let cell:UITableViewCell = (self.tableViewCountries.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell)
        
        let a = self.pickerData[indexPath.row]["country"].string
        //let b = self.pickerData[indexPath.row]["code"]
        
        cell.textLabel?.text = a
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("VCCountrySelection : tableView:didSelectRowAtIndexPath: ")
        print("You have selected cell #\(indexPath.row)!")
        let a = self.pickerData[indexPath.row]["country"].string
        let b = self.pickerData[indexPath.row]["code"].number
        
        print(a,b)
        
        AppDelegate.getAppDelegate().sCountryName = a!
        AppDelegate.getAppDelegate().nCountryCode = b!
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}