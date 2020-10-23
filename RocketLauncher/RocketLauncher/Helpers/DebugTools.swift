//
//  DebugTools.swift
//  CCBaseFramework
//
//  Created by Coskun Caner on 3.04.2019.
//  Copyright © 2019 Coskun Caner. All rights reserved.
//

import UIKit


// MARK: - DEBUGING TOOLS
// Some of Debug Logers
func debugUserDefaults(_ debugMode:Bool = true) {
    // ["onFirstBoot": true, "UserLogedIn": false, "FBLogedIn": false, "isSurveyComplated":false, "BootTime":Date(), "AppToken": "", "AppID": "", "LoginTimeOut":-1]
    if debugMode {
        //        print("---- DEBUG MODE: \(DataModel.shared.DebugMode) ----")
        print("---- USER DEFAULTS ----")
        print("----------------------------------")
        print("onFirstBoot: \(UserDefaults.standard.object(forKey: "onFirstBoot") as? Bool ?? false )")
        print("DebugMode: \(UserDefaults.standard.object(forKey: "DebugMode") as? Bool ?? false )")
        print("UserLogedIn: \(UserDefaults.standard.object(forKey: "UserLogedIn") as? Bool ?? false )")
        print("isRegisteredUser: \(UserDefaults.standard.object(forKey: "isRegisteredUser") as? Bool ?? false )")
        print("isLoginSuspended: \(UserDefaults.standard.object(forKey: "isLoginSuspended") as? Bool ?? false )")
        print("isSurveyComplated: \(UserDefaults.standard.object(forKey: "isSurveyComplated") as? Bool ?? false )")
        print("BootTime: \( (UserDefaults.standard.object(forKey: "BootTime")  as? Date ?? cleanDate).stringDateTimeValue )")
        print("AppID: \(UserDefaults.standard.object(forKey: "AppID")  as? String ?? "" )")
        print("AppToken: \(UserDefaults.standard.object(forKey: "AppToken") as? String ?? "" )")
        //print("RefreshToken: \(UserDefaults.standard.object(forKey: "RefreshToken") as? String ?? "" )")
        print("LoginTimeOut: \(UserDefaults.standard.object(forKey: "LoginTimeOut") as? Int ?? 0)")
        print("DeviceTokenForSNS: \(UserDefaults.standard.object(forKey: "deviceTokenForSNS")  as? String ?? "")")
        print("EndPointARNforSNS: \(UserDefaults.standard.object(forKey: "endpointARNforSNS")  as? String ?? "")")
        print("----------------------------------")
    }
}


func debugDocumentsDirectory(_ debugMode:Bool = true) {
    if debugMode {
        print("---- Documents Directory ----")
        print("----------------------------------")
        print(documentsDirectory)
        print("----------------------------------")
    }
}


func debugFontsSupported(){
    print("--- Supported Fonts on Device ----")
    print("----------------------------------")
    for family: String in UIFont.familyNames
    {
        print("\(family)")
        for names: String in UIFont.fontNames(forFamilyName: family)
        {
            print("== \(names)")
        }
    }
    print("----------------------------------")
}
