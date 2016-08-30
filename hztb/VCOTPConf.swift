//
//  VCOTPConf.swift
//  hztb
//
//  Created by Pivotal on 8/30/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import UIKit

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
    }
    
}
