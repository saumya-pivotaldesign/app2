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


class VCCountrySelection: UIViewController {
    
    internal var jCountries:JSON!
    //internal var pickerData:Array<String>!
    var pickerData: [String] = ["Item 1","Item 2","Item 3", "Item 4", "Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
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
                    let a:String = country.1["country"].string!
                    self.pickerData.append(a)
                }
                print(pickerData)
                print("===========================")
                
                
            }
        }
        // ==========================================
    }
}