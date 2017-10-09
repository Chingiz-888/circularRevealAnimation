//
//  NetworkManager.swift
//  CircularRevealAnimation
//
//  Created by Чингиз Б on 09.03.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//

import Foundation
import UIKit



class NetworkManager {
    
    
    
    
    
    //======= updateUsername() Function ========================================================================
    static func updateUsername() -> Bool {
        
        
        let url = NSURL(string: (GlobalVars.baseUrl + GlobalVars.updateUsernameUrl))!
        var result = false
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest =  GlobalVars.timeoutForNSURLSession       //5.0 sec
        urlconfig.timeoutIntervalForResource = GlobalVars.timeoutForNSURLSession
        let session = URLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest (url: url as URL)
        request.httpMethod = "POST"
        
        
        //**** OUR PAYLOAD ****
        var requestString = String()
        if GlobalVars.userLogin == nil {              //MARK: при первом вызове скорей всего имя пользователя еще не успеет установиться
            GlobalVars.userLogin = "test_user"
        }
        requestString +=   "username=\(GlobalVars.userLogin)"
        requestString +=    "&userId=\(GlobalVars.digestOfUuid)"
        requestString += "&pushToken=\(GlobalVars.pushDeviceToken)"
        request.httpBody = requestString.data(using: String.Encoding.utf8)
        
        
        //system activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        //initializing semaphore
        let task = session.dataTask(with: request as URLRequest, completionHandler:
            {//-------SESSION TASK--------------------------
                (data: Data?, response: URLResponse?, error: Error?)   -> Void in
                
                //Make sure we get an OK response
                guard let realResponse = response as? HTTPURLResponse,
                    realResponse.statusCode == 200 else
                {
                    print("Network -> Not a 200 Code or timeout exceeding")
                    //remove system activity indicator
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    return
                }
                
                //remove system activity indicator
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                //we have answer
                if ( error == nil )
                {
                    let reply = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                    print("Network -> Result from updating username from PHP script = \(reply)")
                    GlobalVars.messageFromServer = reply
                    result = true
                }//----
                else {
                    print("Network -> Some error happened while trying update username")
                    result = false
                }
        }).resume()
        //-----END of SESSION TASK-------------------------------------------------------
        
        
        
        //waiting for semaphore signal
        return result
    }   //======= updateUsername() Function =======================================================================
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}//--- end of class Declaration
