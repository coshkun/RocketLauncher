//
//  Services.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 19.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Services {
    static let main = Services()
    private init() { }
    
    let baseURL = "https://api.spacexdata.com/v3"
    
    let bucketName = "com.cskncnr.RocketLauncher"
    //let folderName = "pictures"
    let baseUrl_S3 = "https://s3.eu-west-2.amazonaws.com/"
    
    var isConnected:Bool { get{ return _isConnected } }; private var _isConnected = false
    let reachabilityManager = Alamofire.NetworkReachabilityManager()
    
    func listenForReachability(_ completion: ((Bool) -> ())? = nil ) {
        self.reachabilityManager?.listener = { status in
            print("*** RM - Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                //Show error state
                self._isConnected = false
            case .reachable(_), .unknown:
                //Hide error state
                self._isConnected = true
            }
            completion?(self.isConnected)
        }
        self.reachabilityManager?.startListening()
    }
    
    // /////////////////////
    // MARK: - EndPoints
    enum EndPoints:String {
        case none
        case getCores             = "/cores"
        case getCoreByID          = "/cores/"               // /cores/{{core_serial}}
        
        case getAllLaunches       = "/launches"
        case getLauncheByID       = "/launches/"            // /launches/{{flight_number}}
        case getUpcomingLaunches = "/launches/upcoming"
    }
}



// //////////////////////////////////
// MARK: - Start of Service Methods
extension Services {
    
    func gelAllLaunches(_ completion: @escaping ((AllLaunchesDTO?, ServiceMessage) -> ()) ) {
        let endPoint = baseURL + EndPoints.getAllLaunches.rawValue
        //let language = lang ?? Localization.main.currentLanguage
        //var parameters:[String:Any] = ["lang":"\(language)"]
        
        let headers = [ "Content-Type":"application/json",
                        "Accept": "application/json",
                        "Accept-Encoding":"gzip, deflate, br",
                        "Cache-Control":"no-cache",
                        "Connection":"keep-alive",
                        "User-Agent":"IOS-\(UIDevice.current.deviceName)/\(UIDevice.current.model)"
        ]
        
        NAIM.startNetworkOperation()                                        //URLEncoding.httpBody
        Alamofire.request(endPoint,  method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            NAIM.stopNetworkOperation()
            guard let data = response.result.value else { completion(nil, .connectionErr); return }
            do {
                let json = try JSON(data: data)
                if let err = json["error"].string,
                    err != "0" {
                    let errText = json["errorText"].stringValue
                    completion(nil, .responseErr(text: errText))
                } else {
                    //everything is ok here..
                    let dto = try AllLaunchesDTO(json: json)
                    completion(dto, .successMsg(text: json["errorText"].stringValue))
                }
            } catch {
                //print("**Hata: \(error)")
                //print("**Hata: \(ServiceError.jsonParsingErr) on: \(endPoint)")
                completion(nil, .jsonParsingErrOn(line:"❌ Error --> File:\(#file) -> Function:\(#function) -> Line:\(#line)"))
            }
        }
    }
    
    func getUpcomingLaunches(_ completion: @escaping ((UpcomingLaunchesDTO?, ServiceMessage) -> ()) ) {
        let endPoint = baseURL + EndPoints.getUpcomingLaunches.rawValue
        //let language = lang ?? Localization.main.currentLanguage
        //var parameters:[String:Any] = ["lang":"\(language)"]
        
        let headers = [ "Content-Type":"application/json",
                        "Accept": "application/json",
                        "Accept-Encoding":"gzip, deflate, br",
                        "Cache-Control":"no-cache",
                        "Connection":"keep-alive",
                        "User-Agent":"IOS-\(UIDevice.current.deviceName)/\(UIDevice.current.model)"
        ]
        
        NAIM.startNetworkOperation()                                        //URLEncoding.httpBody
        Alamofire.request(endPoint,  method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            NAIM.stopNetworkOperation()
            guard let data = response.result.value else { completion(nil, .connectionErr); return }
            do {
                let json = try JSON(data: data)
                if let err = json["error"].string,
                    err != "0" {
                    let errText = json["errorText"].stringValue
                    completion(nil, .responseErr(text: errText))
                } else {
                    //everything is ok here..
                    let dto = try UpcomingLaunchesDTO(json: json)
                    completion(dto, .successMsg(text: json["errorText"].stringValue))
                }
            } catch {
                //print("**Hata: \(error)")
                //print("**Hata: \(ServiceError.jsonParsingErr) on: \(endPoint)")
                completion(nil, .jsonParsingErrOn(line:"❌ Error --> File:\(#file) -> Function:\(#function) -> Line:\(#line)"))
            }
        }
    }
    
    func getLauncheBy(_ flightNumber:Int, _ completion: @escaping ((SingleLauncheDTO?, ServiceMessage) -> ()) ) {
        let endPoint = baseURL + EndPoints.getLauncheByID.rawValue + "\(flightNumber)"
        //let language = lang ?? Localization.main.currentLanguage
        //var parameters:[String:Any] = ["lang":"\(language)"]
        
        let headers = [ "Content-Type":"application/json",
                        "Accept": "application/json",
                        "Accept-Encoding":"gzip, deflate, br",
                        "Cache-Control":"no-cache",
                        "Connection":"keep-alive",
                        "User-Agent":"IOS-\(UIDevice.current.deviceName)/\(UIDevice.current.model)"
        ]
        
        NAIM.startNetworkOperation()                                        //URLEncoding.httpBody
        Alamofire.request(endPoint,  method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            NAIM.stopNetworkOperation()
            guard let data = response.result.value else { completion(nil, .connectionErr); return }
            do {
                let json = try JSON(data: data)
                if let err = json["error"].string,
                    err != "0" {
                    let errText = json["errorText"].stringValue
                    completion(nil, .responseErr(text: errText))
                } else {
                    //everything is ok here..
                    let dto = try SingleLauncheDTO(json: json)
                    completion(dto, .successMsg(text: json["errorText"].stringValue))
                }
            } catch {
                //print("**Hata: \(error)")
                //print("**Hata: \(ServiceError.jsonParsingErr) on: \(endPoint)")
                completion(nil, .jsonParsingErrOn(line:"❌ Error --> File:\(#file) -> Function:\(#function) -> Line:\(#line)"))
            }
        }
    }
}





// /////////////////
// MARK: - Network Helpers
extension Services {
    // /////////////////
    // Generic Image Downloader whit Alamo
    func getImageFromURL(urlString:String, completion: @escaping (UIImage) -> Void ) {
        Alamofire.request(urlString, method: .get ).responseData(completionHandler: { (respondingData) in
            DispatchQueue.main.async(execute: {
                guard let d = respondingData.result.value,
                      let image = UIImage(data: d, scale: UIScreen.main.scale)
                else { return }
                completion(image)
            })
        })
    }
}


// /////////////////
// MARK: - Network Activity Indicator Manager (NAIM)
class NAIM: NSObject {
    
    private static var loadingCount = 0
    
    class func startNetworkOperation() {
        if loadingCount == 0 {
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        }
        loadingCount += 1
    }
    
    class func stopNetworkOperation() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        }
    }
}
