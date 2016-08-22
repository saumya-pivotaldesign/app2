//
//  ViewController.swift
//  hztb
//
//  Created by Pivotal on 8/22/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewControllerOne: UIViewController {
    
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("ViewControllerOne:viewDidLoad")
        print("keychain",keychain)
        
        getKeyChainTest()
        //setKeyChainTest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewControllerOne {
    private func setKeyChainTest(){
        print("setKeyChainTest   ============ ")
        keychain.set("hello world", forKey: "my key")
        print("setKeyChainTest / ============ ")
    }
    private func getKeyChainTest(){
        print("getKeyChainTest   ============ ")
        let a = keychain.get("my key")
        //print(a)
        if(a == nil ){
            print("KeyChain : Nothing found for 'my key'")
        }else{
            print("KeyChain : value of 'my key'",a)
        }
        print("getKeyChainTest / ============ ")
    }

}
