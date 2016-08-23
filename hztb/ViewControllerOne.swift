//
//  ViewController.swift
//  hztb
//
//  Created by Pivotal on 8/22/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import UIKit
import KeychainSwift
import SwiftCSV


class ViewControllerOne: UIViewController {
    
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("ViewControllerOne:viewDidLoad")
        print("keychain",keychain)
        
        getKeyChainTest()
        //setKeyChainTest()
        //clearKeyChain()
        
        loadCSV()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewControllerOne {
    //MARK: - KeyChain Exploration
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
    private func clearKeyChain(){
        print("ViewControllerOne:clearKeyChain   ============ ")
        keychain.delete("my key") // Remove single key
        keychain.clear() // Delete everything from app's Keychain. Does not work on macOS.
        print("ViewControllerOne:clearKeyChain / ============ ")
    }

}

//MARK: - CSV test
extension ViewControllerOne {
    private func loadCSV(){
        
        print("===== loadCSV  ======")
        
        let tsv:CSV
        
        // With a custom delimiter, errors, and custom encoding
        do {
            //let tsv = CSV(string: "id\tname\tage\n1\tAlice\t18", delimiter: "\t")
            
            tsv = try CSV(name: "countries.csv")
            
            print("========== Rows ===============")
            print(tsv.rows)
            print("========== Coulumns ===============")
            print(tsv.columns)
            
            //let tsv = try CSV(name: "users.tsv", delimiter: tab, encoding: NSUTF8StringEncoding)
            
        } catch {
            // Error handling
            print("===== loadCSV : Error ======")
        }
        print("===== loadCSV / ======")
    }
}

