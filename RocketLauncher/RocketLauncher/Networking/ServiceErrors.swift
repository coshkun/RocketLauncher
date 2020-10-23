//
//  ServiceErrors.swift
//  CCBaseFramework
//
//  Created by Coskun Caner on 3.04.2019.
//  Copyright © 2019 Coskun Caner. All rights reserved.
//

import Foundation
import TTGSnackbar

enum ServiceMessage: Error {
    case connectionErr
    case jsonParsingErr
    case jsonParsingErrOn(line:String)
    case responseErr(text:String)
    case successMsg(text:String)
}

extension ServiceMessage {
    static func verboseJsonParsingError() -> ServiceMessage {
        return ServiceMessage.jsonParsingErrOn(line: "❌ ==> Func:\(#function) ==> On Line:\(#line)")
    }
    static func verboseBadServiceError() -> ServiceMessage {
        return ServiceMessage.responseErr(text: "❌ ==> Func:\(#function) ==> On Line:\(#line)")
    }
}


class ErrorManager {
    static let main = ErrorManager()
    private init(){ }
    
    func handleStatesAsync(for message:ServiceMessage, onSucces: @escaping () -> () ) {
        switch message {
        case .responseErr(let txt):
            print("*** Conncetion Error", txt)
            let snack = TTGSnackbar(message: "ERROR: \(txt)", duration: .middle)
            snack.show()
        case .connectionErr:
            let snack = TTGSnackbar(message: "ERROR: Internet connection fails", duration: .middle)
            snack.show()
        case .jsonParsingErrOn(let err):
            print("*** Structure Parsing Error:\n", err)
        case .jsonParsingErr:
            print("*** Structure Parsing Error")
        case .successMsg( _):
            //print(response!.result)
            print("*** Structure Updated!")
            DispatchQueue.main.async {
                onSucces()
            }
        }
    }
    
    func handleStatesAsync<T> (_ typeof:T?, message:ServiceMessage, onSucces: @escaping () -> (), onFail: (() -> ())? = nil ) {
        switch message {
        case .responseErr(let txt):
            print("*** Conncetion Error", txt)
            let snack = TTGSnackbar(message: "ERROR: \(txt)", duration: .middle)
            snack.show()
            DispatchQueue.main.async {
                onFail?()
            }
        case .connectionErr:
            let snack = TTGSnackbar(message: "ERROR: Internet connection fails", duration: .middle)
            snack.show()
            DispatchQueue.main.async {
                onFail?()
            }
        case .jsonParsingErrOn(let err):
            if typeof != nil {
                let typename = type(of: typeof!)
                print("*** \(typename) Structure Parsing Error:\n", err)
            } else { print("*** UNKNOWN TYPE Structure Parsing Error:\n", err) }
            DispatchQueue.main.async {
                onFail?()
            }
        case .jsonParsingErr:
            if typeof != nil {
                let typename = type(of: typeof!)
                print("*** \(typename) Structure Parsing Error.")
            } else { print("*** UNKNOWN TYPE Structure Parsing Error.") }
            DispatchQueue.main.async {
                onFail?()
            }
        case .successMsg( _):
            let typename = type(of: typeof!)
            print("*** \(typename) Item Updated!")
            DispatchQueue.main.async {
                onSucces()
            }
        }
    }
}
