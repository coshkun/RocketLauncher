//
//  DataModel.swift
//  v.0.4
//
//  Created by Coskun Caner on 28/11/2017.
//  Copyright © 2017 Coskun Caner. All rights reserved.
//

import Foundation

class DataModel {
    static let shared = DataModel()
    
    var context = DataContext()
    
    let sharedAppGroup = "" // leave this empty string if you work in local folder
    var appMode = "live"    // "live" // "test"   -> is the platform switch
    
    
    // Public Properties
    var AppID:String! = {
        return UserDefaults.standard.object(forKey: "AppID") as? String
    }()
    
    var DebugMode:Bool {
        get { return UserDefaults.standard.bool(forKey: "DebugMode") }
        set { return UserDefaults.standard.set(newValue, forKey: "DebugMode") }
    }
    //-End Of Public Props
    
    /// SOME COSNTANTS RELEVANT TO OUT APP
    let googleMapsAPIkey = ""
    
    
    private init() {
        if self.sharedAppGroup.count > 0 { loadContext_sharedContainer() } else { loadContext() }
        
        let firstUse:Bool? = UserDefaults.standard.object(forKey: "onFirstBoot") as? Bool
        if firstUse == nil {
            registerDefaultValues()
            UserDefaults.standard.set(false, forKey: "onFirstBoot")
            //let appID = AES256CBC.generatePassword()
            let appID = "" + UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")  // Bundle.main.bundleIdentifier ?? "" // - we can use bundle-id, alternatively
            UserDefaults.standard.set(appID, forKey: "AppID")
        } else {
            // set boot defaults for next boots
            UserDefaults.standard.synchronize()
        }
    }
    
    // File System
    public func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] as URL
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("localDB.plist")
    }
    
    func sharedContainer_dataFilePath() -> URL {
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.sharedAppGroup)
        if let shareConURL = sharedContainerURL {
            let storeURL = shareConURL.appendingPathComponent("localDB.plist")
            return storeURL
        } else {
            return dataFilePath() // failsafe option if we cant access to shared container.
        }
    }
    
    func saveContext() {
        //        let data = NSMutableData()
        //        let archiver = NSKeyedArchiver(forWritingWith: data)
        //        archiver.encode(context, forKey: "DataContext")
        //        archiver.finishEncoding()
        //        data.write(to: dataFilePath(), atomically: true)
        
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: context)
        // print(dataToSave) // -Debug
        let b64str = dataToSave.base64EncodedString()
//        let appID = UserDefaults.standard.string(forKey: "AppID")!
//        let encrypted = AES256CBC.encryptString(b64str, password: appID)! // Encrypted
        // print(encrypted) // -Debug
        print("-------")
//        let data = encrypted.data(using: .utf8, allowLossyConversion: false) // Encrypted
        let data = b64str.data(using: .utf8, allowLossyConversion: false)      // Un-Encrypted
        
        // print(String(data:data!, encoding: .utf8))  //-Debug
        let _ = try? data?.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    }
    
    func loadContext() {
        let path = dataFilePath().path
        if let data = NSData(contentsOfFile: path) {
            
            print("-- START OF DECODING --")
//            guard let encoded = String(data:data, encoding: .utf8) else { return }  // Encrypted
            guard let unencoded = String(data:data, encoding: .utf8) else { return }  // Un-Encrypted
            
            // print(encoded) // -Debug
            print("-------")
//            let appID = UserDefaults.standard.string(forKey: "AppID")!                  // Encrypted
//            let decryptedB64 = AES256CBC.decryptString(encoded, password: appID)!       // Encrypted
            // print(decryptedB64) // -Debug
            print("-------")
//            let solvedData = Data(base64Encoded: decryptedB64)!                         // Encrypted
            let solvedData = Data(base64Encoded: unencoded)!                              // Un-Encrypted
            
            //print(String(data:solvedData, encoding: String.Encoding.utf8)) // this string po dont working somehow, it is an internal bug, we dont mind it
            let context = NSKeyedUnarchiver.unarchiveObject(with: solvedData) as! DataContext // something to test in future
            self.context = context
            print("-- Context Decoded --")
            // print(context) // -Debug
            print("-------")
            
            //
            //            //let unarchiver = NSKeyedUnarchiver(forReadingWith: solvedData)
            //            let unarchiver = NSKeyedUnarchiver(forReadingWith: Data(referencing: data))  // working with old uncrypted logic
            //            context = unarchiver.decodeObject(forKey: "DataContext") as! DataContext
            //            unarchiver.finishDecoding()
        }
    }
    
    func saveContext_sharedContainer() {
        print("-------"); print("----Saving to Shared Container----")
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: context)
        // print(dataToSave) // -Debug
        let b64str = dataToSave.base64EncodedString()
//        let appID = UserDefaults.standard.string(forKey: "AppID")!
//        let encrypted = AES256CBC.encryptString(b64str, password: appID)!
        // print(encrypted) // -Debug
        print("-------")
//        let data = encrypted.data(using: .utf8, allowLossyConversion: false)
        let data = b64str.data(using: .utf8, allowLossyConversion: false)      // Un-Encrypted
        // print(String(data:data!, encoding: .utf8))  //-Debug
        let _ = try? data?.write(to: sharedContainer_dataFilePath(), options: Data.WritingOptions.atomic)
    }
    
    func loadContext_sharedContainer() {
        print("-------"); print("----Loading From Shared Container----")
        let path = sharedContainer_dataFilePath().path
        print("Shared Container Path: \(path)")
        print("-------")
        if let data = NSData(contentsOfFile: path) {
            
            print("-- START OF DECODING --")
//            guard let encoded = String(data:data, encoding: .utf8) else { return }
            guard let unencoded = String(data:data, encoding: .utf8) else { return }  // Un-Encrypted
            
            // print(encoded) // -Debug
            print("-------")
//            let appID = UserDefaults.standard.string(forKey: "AppID")!
//            let decryptedB64 = AES256CBC.decryptString(encoded, password: appID)!
            // print(decryptedB64) // -Debug
            print("-------")
//            let solvedData = Data(base64Encoded: decryptedB64)!
            let solvedData = Data(base64Encoded: unencoded)!
            
            //print(String(data:solvedData, encoding: String.Encoding.utf8)) // this string po dont working somehow, it is an internal bug, we dont mind it
            let context = NSKeyedUnarchiver.unarchiveObject(with: solvedData) as! DataContext // something to test in future
            self.context = context
            print("-- Context Decoded --")
            // print(context) // -Debug
            print("-------")
        }
    }
    
    
    // USER DEFAULTS   -- use if necessary
    func registerDefaultValues(){
        // clear if initialized before (i may not be posible)
        let domain = Bundle.main.bundleIdentifier!
        //        UserDefaults.standard.removePersistentDomain(forName: domain)
        //        UserDefaults.standard.synchronize()
        
        // Registery no more working on IOS 11
        let dictionary: [String:Any] = ["onFirstBoot": true,
                                        "DebugMode": true,
                                        "UserLogedIn": false,
                                        "isRegisteredUser": false,
                                        "isLoginSuspended":false,
                                        "isSurveyComplated":false,
                                        "BootTime":Date(),
                                        "AppID": "",
                                        "AppToken": "",
                                        "RefreshToken":"",
                                        "deviceTokenForSNS":"",
                                        "endpointARNforSNS":"",
                                        "LoginTimeOut":-1]
        /*
         let userdef = UserDefaults.standard
         userdef.register(defaults: dictionary)
         */
        UserDefaults.standard.setPersistentDomain(dictionary, forName: domain)
        
        UserDefaults.standard.synchronize()
    }
}



// NSData Extentions
extension String
{
    init?(data : NSData, encoding : String.Encoding)
    {
        var buffer = Array<UInt8>(repeating: 0x00, count: data.length)
        data.getBytes(&buffer, length: data.length)
        self.init(bytes: buffer, encoding: encoding)
    }
}




