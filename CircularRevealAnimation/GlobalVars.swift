//
//  GlobalVars.swift
//  CircularRevealAnimation
//
//  Created by Чингиз Б on 09.03.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//



import UIKit



class GlobalVars {
    
    static var userLogin       = String()
    static var userPassword    = String()
    static var digestOfUuid    = String()
    static var pushDeviceToken = String()
    
    static let baseUrl           = "http://www.it-box.info/examples/honest_food/"
    static let updateUsernameUrl = "api/saveuser.php"
    static let timeoutForNSURLSession = 5.0
    
    static var messageFromServer = String()
    
    
    
    
    /*   Our function for retrieving UUID and getting md5 hash from it
     *   So we get our userId parameter that we can use on backend to differentiate user
     */
    static func getPhoneId() -> String
    {
        //Swift 3.0 syntax:  UIDevice.current.identifierForVendor?.uuidString
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        if (uuid != nil)
        {
            digestOfUuid = md5(uuid: uuid!)
        }
        else{
            digestOfUuid = ""
        }
        return digestOfUuid
    }
    
    
    /*   Just standart md5 hashing function in Swift 2.0 syntax
     *   It demands CommonCrypto/CommonCrypto.h which was included in GeoApp-Bridging-Header.h
     */
    static func md5(uuid: String) -> String {
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        let data = uuid.data(using: String.Encoding.utf8)
        
        if  (data != nil)  {
            //CC_MD5(data!.bytes, CC_LONG(data!.count), &digest)
            
            data?.withUnsafeBytes { bytes in
                CC_MD5(bytes, CC_LONG((data?.count)!), &digest)
            }
            
        }
        
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        digestOfUuid = digestHex
        
        return digestOfUuid
    }
    
    
    
    
    
}//--- end of class declaration -----
