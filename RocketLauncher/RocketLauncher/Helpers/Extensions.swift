//
//  Extensions.swift
//  CCBaseFramework
//
//  Created by Coskun Caner on 3.04.2019.
//  Copyright © 2019 Coskun Caner. All rights reserved.
//

import UIKit
import MobileCoreServices

//Lazy GLobal Loaders
var documentsDirectory:URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0] as URL
}()

var tempDirectory:URL = {
    let paths = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    return paths as URL
}()

var cleanDate: Date = {
    if _cleanDate != nil { return _cleanDate } else {
        var dateComponents = DateComponents()
        dateComponents.year = 0000
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let cleanDate = Calendar.current.date(from: dateComponents)
        return cleanDate!
    }
}()
var _cleanDate:Date!

var dateFormatter: DateFormatter = {
    if _dateFormatter != nil { return _dateFormatter } else {
        let frmtr = DateFormatter()
        frmtr.locale = Locale.current
        frmtr.timeZone = TimeZone(abbreviation: "GMT+0:00") // Buna sakın dokunma, çevirme işlemi hatalı döner.
        return frmtr
    }
}()
var _dateFormatter:DateFormatter!

var numberFormatter: NumberFormatter = {
    if _numberFormatter != nil { return _numberFormatter } else {
        let frmtr = NumberFormatter()
        frmtr.locale = Locale.current
        return frmtr
    }
}()
var _numberFormatter:NumberFormatter!

var timeFormatter: DateComponentsFormatter = {
    if _timeFormatter != nil { return _timeFormatter } else {
        let frmtr = DateComponentsFormatter()
        return frmtr
    }
}()
var _timeFormatter: DateComponentsFormatter!


// *****************************************************
// MARK: - Start of Extensions
// *****************************************************
//TimeSpan to String
extension TimeInterval {
    var stringValue: String {
        if self.isNaN || !self.isCanonical { return "--:--:--" }
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        guard let sonuc = timeFormatter.string(from: self) else { return "--:--:--" }
        return sonuc
    }
}

//TimeSpan to String
extension Date {
    var stringValue: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "dd.MM.yyyy"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringDateTimeValue: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "dd.MM.yyyy h:mm:ss"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringTimeValue: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "HH:mm:ss"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringTimeWithoutSecondsValue: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "HH:mm"   // Set this format exactly same as service result
        var sonuc = "--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringValueTR: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "dd/MM/yyyy"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringValueGB: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "yyyy/MM/dd"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    var stringDateTimeValueGB: String {
        //if self.isNaN || !self.isCanonical { return "--:--:--" }
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"   // Set this format exactly same as service result
        var sonuc = "--/--/--"
        sonuc = dateFormatter.string(from: self)
        return sonuc
    }
    
    
    init(fromString:String, withFormat:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = withFormat //"dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        self = formatter.date(from: fromString) ?? cleanDate
    }
    
    /**
     Example, zoneTime: "GMT+0:00"
     */
    init(fromString:String, withFormat:String, zoneTime:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = withFormat //"dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: zoneTime)
        self = formatter.date(from: fromString) ?? cleanDate
    }
}


//String To Number Convertors
extension String {
    var numberValue:NSNumber {
        if self.isEmpty { return 0 }
        numberFormatter.numberStyle = .none
        guard let sonuc = numberFormatter.number(from: self) else { return 0 }
        return sonuc
    }
    var currencyValue:NSNumber {
        if self.isEmpty { return 0 }
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        guard let sonuc = numberFormatter.number(from: self) else { return 0 }
        return sonuc
    }
    var currencyValueGB:NSNumber {
        if self.isEmpty { return 0 }
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        guard let sonuc = numberFormatter.number(from: self) else { return 0 }
        return sonuc
    }
    var dateValue:Date? {
        if self.isEmpty { return Date() }
        dateFormatter.dateFormat = "dd.MM.yyyy"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return Date() }
        return sonuc
    }
    var dateValueGB:Date? {
        if self.isEmpty { return Date() }
        dateFormatter.dateFormat = "yyyy.MM.dd"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return Date() }
        return sonuc
    }
    var dateValueFB:Date? {
        if self.isEmpty { return Date() }
        dateFormatter.dateFormat = "MM.dd.yyyy"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return Date() }
        return sonuc
    }
    var dateTimeValue:Date? {
        if self.isEmpty { return Date() }
        dateFormatter.dateFormat = "dd.MM.yyyy h:mm:ss"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return Date() }
        return sonuc
    }
    var dateTimeValueGB:Date? {
        if self.isEmpty { return Date() }
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return Date() }
        return sonuc
    }
    var timeValue:Date? {
        if self.isEmpty { return cleanDate }
        dateFormatter.defaultDate = cleanDate
        dateFormatter.dateFormat = "hh:mm:ss"   // Set this format exactly same as service result
        guard let sonuc = dateFormatter.date(from: self) else { return cleanDate }
        return sonuc
    }
    
    init(fromDate:Date, withFormat:String) {
        let formatter = DateFormatter()
        formatter.defaultDate = cleanDate
        formatter.dateFormat = withFormat //"dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let sonuc = formatter.string(from: fromDate)
        self = sonuc
    }
    
    /// leading Zero(s)
    /**
     - Usage:
     let s = String(123)
     s.leftPadding(toLength: 8, withPad: "0") // "00000123"
    */
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        
        guard toLength > self.count else { return self }
        
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
}




/// Extents UIButtons to add actin with closures
public class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

public class NullableClosureSleeve {
    let closure: (()->())?
    
    init (_ closure: (()->())? ) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure?()
    }
}

extension UIControl {
    func add (for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}










// MARK: - Constraints With Visual Formatting
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)) //NSLayoutFormatOptions()
    }
}





// MARK: - Swift Logical XOR operator
precedencegroup BooleanPrecedence { associativity: left }
infix operator ^^ : BooleanPrecedence
/**
 Swift Logical XOR operator
 ```
 true  ^^ true   // false
 true  ^^ false  // true
 false ^^ true   // true
 false ^^ false  // false
 ```
 - parameter lhs: First value.
 - parameter rhs: Second value.
 */
func ^^(lhs: Bool, rhs: Bool) -> Bool {
    return lhs != rhs
}











//MARK: - Navigational Helpers (TOP MOST CONTROLLER)
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
/* USAGE:
     if let topCon = UIApplication.topViewController() {
        topCon.present(UIAlertController(title: "Done!", message: "Congratilations :)", preferredStyle: .alert), animated: true, completion: nil)
     }
 */
}





// IPhoneX Edge Detection Helpers
extension UIDevice {
    static var isIphoneX: Bool {
        var modelIdentifier = ""
        if isSimulator {
            modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        } else {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            modelIdentifier = String(cString: machine)
        }
        
        return modelIdentifier == "iPhone10,3" || modelIdentifier == "iPhone10,6" || modelIdentifier.starts(with: "iPhone11,")
    }
    
    //gives same result with above
    var deviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    //get models known name
    var modelName: String {
        switch UIDevice.current.deviceName {
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhoneX"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4":
            return "iPhone XS Max"
        case "iPhone11,6":
            return "iPhone XS Max China"
        case "iPhone11,8":
            return "iPhone XR"
        default:
            return "unknown"
        }
    }
    
    // to get overflowing top
    static func extraTop() -> CGFloat {
        
        var top: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            
            if let t = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                top = t
            }
        }
        return top
    }
    
    // to get overflowing bottom
    static func extraBottom() -> CGFloat {
        
        var bottom: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            
            if let b = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                bottom = b
            }
        }
        return bottom
    }
}







extension UITableView {
    //TABLE HELPERS
    func reloadWithoutTableAnimation(_ completion:(()->())? = nil ) {
        //RELOAD SECTION WITHOUT TABLE ANIMATION
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.none) // update table face
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
        DispatchQueue.main.async { completion?() }
    }
}





// Camelized String Support
fileprivate let badChars = CharacterSet.alphanumerics.inverted
extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }

    var camelized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars)

        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([first] + rest).joined(separator: "")
    }
}






