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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        initialCheck()
    }
}

extension VCAppEntry {
    private func initialCheck(){
        print("VCAppEntry:initialCheck:")
        //let pivdUtil = PIVDUtil()
        pivdUtil.initTheUtil()
        pivdUtil.initialCheck()
    }
}