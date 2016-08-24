//
//  PIVDUtil.swift
//  hztb
//
//  Created by Pivotal on 8/24/16.
//  Copyright © 2016 hztb.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PIVDUtil {
    internal func initTheUtil(){
        print("PIVDUtil:initTheUtil:")
    }
    internal func doRESTCheck(){
        print("PIVDUtil:doRESTCheck:")
        let sURL:NSURL = NSURL(string: "https://httpbin.org/post")!; // post - request
        let session:NSURLSession = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: sURL)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask:NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            print("json data")
            do {
                print("do")
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as!NSDictionary
                // use jsonData
                NSLog("%@", jsonData)
            } catch {
                // report error
                print("ERROR")
            }
        }
        
        // finally call this
        dataTask.resume()
        //
    }
    
    //MARK: - initialCheck
    internal func initialCheck(){
        let url = "http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/app/initialcheck"
        let headers = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":"en-US",
            "REQUEST_ID":"1"
        ]
        let parameters = [
            "versionCode" : "1",
            "versionName" : "1.0"
        ]
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                print("post : request=",response.request)
                print("post : response=",response.response)
                print("post : data=",response.data)
                print("post : result=",response.result)
                // SwiftyJSON
                //let json = JSON(data: dataFromNetworking)
                let jsonOBJ = JSON((response.result.value)!)
                
                print("===========================================")
                print("jsonOBJ=",jsonOBJ)
                print("jsonOBJ[0]=",jsonOBJ[0])
                print("jsonOBJ[1]=",jsonOBJ[1])
                print("jsonOBJ['json']=",jsonOBJ["json"])
                print("jsonOBJ[\"json\"][\"foo\"]=",jsonOBJ["json"]["foo"])
                print("===========================================")
        }
    }// END initialCheck
}