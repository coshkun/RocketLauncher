//
//  DataContext.swift
//
//  Created by Coskun Caner on 8.03.2019.
//  Copyright © 2019 Coskun Caner. All rights reserved.
//

import UIKit

class DataContext: NSObject, NSCoding {
    
    // Initialize Models Here
    //var AppConfig: [Settings]?
    //var UlkelerBolgeler:Bolgeler!
    
//    var config: ServiceConfig! = ServiceConfig()
//    var user: UserInfo!        = UserInfo()
//    var basket:BasketInfo!     = BasketInfo()
    
    var KullaniciAdi:String = ""
    var Sifre:String = ""
    
    
    //var UserLocation:MANLocation! = MANLocation()
    
    override init() {
        //FilterOption(sorting: SortType(), category: Category(), attributes: [B2Attribute]())
        //        Uygulamalar = [Uygulama]()
        //        Reklam = ReklamInfo()
        //config = ServiceConfig()
        //UlkelerBolgeler = Bolgeler()
        //CheckLists = [CheckList]()
        super.init()
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        

//        aCoder.encode(config.serialize(), forKey: "config")
//        aCoder.encode(user.serialize(), forKey: "user")
        
        aCoder.encode(KullaniciAdi, forKey: "KullaniciAdi")
//        let appID = UserDefaults.standard.string(forKey: "AppID")!
//        let encrypted = AES256CBC.encryptString(Sifre, password: appID)
//        aCoder.encode(encrypted, forKey: "Sifre")
         aCoder.encode(Sifre, forKey: "Sifre")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
////        config = aDecoder.decodeObject(forKey: "ServiceConfig") as? ServiceConfig ?? ServiceConfig()
////        user = aDecoder.decodeObject(forKey: "UserInfo") as? User ?? User()
//        config = ServiceConfig.deserialize(from: aDecoder.decodeObject(forKey: "config") as? String ?? "") ?? ServiceConfig()
//        user   = UserInfo.deserialize(from: aDecoder.decodeObject(forKey: "user") as? String ?? "" ) ?? UserInfo()
        
        KullaniciAdi = aDecoder.decodeObject(forKey: "KullaniciAdi") as? String ?? ""
//        let encrypted = aDecoder.decodeObject(forKey: "Sifre") as? String ?? ""
//        let appID = UserDefaults.standard.string(forKey: "AppID")!
//        let decrypted = AES256CBC.decryptString(encrypted, password: appID)
//        Sifre = decrypted ?? ""
        Sifre = aDecoder.decodeObject(forKey: "Sifre") as? String ?? ""
        super.init()
    }
    
}
