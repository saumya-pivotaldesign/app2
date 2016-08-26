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
    internal func initialCheck(refObj:VCAppEntry,vCode:String,vName:String){
        print("PIVDUtil:initialCheck:")
        
        let url = "http://ec2-52-90-83-150.compute-1.amazonaws.com:8080/hztb-servicemanager/app/initialcheck"
        let headers = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":"en-US",
            "REQUEST_ID":"1"
        ]
        // Example: "versionCode" : "1" / "versionName": "1.0"
        let parameters = [
            "versionCode" : vCode,
            "versionName" : vName
        ]
        print("PIVDUtil:initialCheck:parameters:",parameters)
        Alamofire.request(.POST, url,headers:headers, parameters:parameters , encoding: .JSON)
            .responseJSON { (response) in
                print("PIVDUtil:initialCheck: post : request=",response.request)
                print("PIVDUtil:initialCheck: post : response=",response.response)
                print("PIVDUtil:initialCheck: post : data=",response.data)
                print("PIVDUtil:initialCheck: post : result=",response.result)
                // SwiftyJSON
                //let json = JSON(data: dataFromNetworking)
                let jsonOBJ = JSON((response.result.value)!)
                
                print("===========================================")
                print("PIVDUtil:initialCheck: jsonOBJ=",jsonOBJ)
                print("PIVDUtil:initialCheck: jsonOBJ.status=",jsonOBJ["status"])
                print("PIVDUtil:initialCheck: jsonOBJ.isError=",jsonOBJ["isError"])
                print("PIVDUtil:initialCheck: jsonOBJ.needUpdate=",jsonOBJ["needUpdate"])
                print("PIVDUtil:initialCheck: jsonOBJ.header.status=",jsonOBJ["header"]["status"])
                print("PIVDUtil:initialCheck: jsonOBJ.header.requestId=",jsonOBJ["header"]["requestId"])
                print("===========================================")
                
                // HTTP Status Code
                let sCode = (response.response)?.statusCode
                //print("sCode",sCode)
                
                if(sCode==200){
                    if(jsonOBJ["isError"]==false){
                        print("PIVDUtil:initialCheck: isError : NO")
                        if(jsonOBJ["needUpdate"]==false){
                            print("PIVDUtil:initialCheck: NEED UPDATE : NO")
                            //refObj.onDoneWithInitialCheck()
                            
                            // everything is alright, move on
                            let notification = NSNotification(name: AppStaticNames.INIT_CHECK_DONE, object:self, userInfo: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notification)
                            
                        }else{
                            print("PIVDUtil:initialCheck: NEED UPDATE : YES")
                            refObj.showAlertMessage("Need Update")
                        }
                    }else{
                        print("PIVDUtil:initialCheck: isError : YES")
                        refObj.showAlertMessage("error")
                    }
                }else if(sCode==400){
                    refObj.showAlertMessage("bad request","Info")
                }else{
                    refObj.showAlertMessage("request is unable to process at this time","Info")
                }
                
        }
    }// END initialCheck
    
    internal func test(){
        print("test ============================ ")
    }
}