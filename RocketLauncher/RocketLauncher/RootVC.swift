//
//  RootVC.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 17.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import UIKit
import TTGSnackbar
import Lottie

class RootVC: UIViewController {
    static let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootVC") as! RootVC
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    @IBOutlet weak var animationContainer:UIView!
    
    var navigation:MainNavigationController!
    //var masterPage:MasterTabBarVC!
    var animationView:AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLoadingAnimation()
        //Debugging
        debugFontsSupported()
        debugDocumentsDirectory()
        debugUserDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        connectToServices()
    }
    
    func setupLoadingAnimation() {
        animationView = .init(name: "root_loading_2")
        animationView!.frame = animationContainer.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.0
        animationContainer.addSubview(animationView!)
        animationView!.play()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK - NAVIGATIONS:Push
    public func pushVC(named:String, animated:Bool = true) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: named) {
            navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    // MARK - NAVIGATIONS:Present
    public func presentVC(named:String, animated:Bool = true, completion: (() -> Void)? = nil) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: named) {
            navigationController?.present(vc, animated: animated, completion: completion)
        }
    }
}







class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 221/255.0, green: 4/255.0, blue: 43/255.0, alpha: 1.0) //primaryRed
        isNavigationBarHidden = true
    }
    
    // this one locks the device to Portraid orientation from root
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
}








extension RootVC {
    
    func connectToServices() {
        //register to the connectivity service
        Services.main.listenForReachability()
        
        //Check current status
        if let connected = Services.main.reachabilityManager?.isReachable {
            if connected {
                // Network is connected here
                
                Services.main.gelAllLaunches { (response, message) in
                    ErrorManager.main.handleStatesAsync(response?.result, message: message) {
                        // Store Data And Push to List Page
                        DataModel.shared.context.allLaunches = response!.result
                        self.pushVC(named: "AllLaunchesVC", animated: true)
                    }
                }
                return
                
            } else {
                // user is offline here..
                if DataModel.shared.context.allLaunches.count > 0 {
                    // alert before push
                    let snack = TTGSnackbar(message: "Please connect to the internet for updated results!", duration: .middle)
                    snack.show()
                    // wait 3 sec to show the message
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.pushVC(named: "AllLaunchesVC", animated: true)
                    }
                    return // to show previously saved data
                }
                
                // Kick User to Offline page
                let snack = TTGSnackbar(message: "You are offline, pls connect to the internet!", duration: .middle)
                snack.show()
            }
        }
    }
}
