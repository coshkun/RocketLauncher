//
//  LaunchDetailVC.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 19.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import UIKit
import Kingfisher

class LaunchDetailVC:UIViewController {
    
    @IBOutlet weak var pictureView:UIView!
    @IBOutlet weak var pictureIV:UIImageView!
    
    @IBOutlet weak var missionNameTF:UITextField!
    @IBOutlet weak var launchSiteTF:UITextField!
    @IBOutlet weak var departureTimeTF:UITextField!
    @IBOutlet weak var detailTX:UITextView!
    
    var item:Launch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureView.layer.cornerRadius = 10
        pictureView.layer.masksToBounds = true
        
        detailTX.textContainerInset = UIEdgeInsets(top: 2, left: -4, bottom: 2, right: -4)
        
        // Biding Example for Stored Data
//        if let launche = item {
//            // fill-up current data
//            fillDataFrom(launche)
//        }
        
        // But Challange asks that: "Launch detail data should getted from 'launches/{flightNumber}' "
        // So let we fetch it from service
        reloadData()
    }
    
    
    func reloadData(_ completion:(()->())? = nil) {
        guard let flightNumber = item?.flightNumber else {return}
        Services.main.getLauncheBy(flightNumber) { (respone, message) in
            //all asyncs are thread safe, turns back to MainQueue
            ErrorManager.main.handleStatesAsync(respone?.result, message: message) {
                self.fillDataFrom(respone!.result)
                completion?()
            }
        }
    }
    
    func fillDataFrom(_ launche:Launch) {
        // fill-up current data
        missionNameTF.text = launche.missionName
        launchSiteTF.text = launche.launchSite.siteName
        
        let date = Date(fromString: launche.launchDateUTC, withFormat: "yyyy-MM-dd'T'hh:mm:ss.sss'Z'")
        departureTimeTF.text = date.stringDateTimeValue + " in UTC"
        
        detailTX.text = launche.details
        
        let placeHolder = UIImage(named: "image_placeholder_640x320")
        guard let link = launche.links.flickrImages.first,
              let url = URL(string: link) else {
            pictureIV.image = placeHolder
            return
        }
        pictureIV.kf.setImage(with: url, placeholder: placeHolder, completionHandler: { (_image, _, _, _) in
            if let image = _image {
                // if portraid, fit the image to prevent zoom effect
                self.pictureIV.contentMode = image.size.height > image.size.width ? .scaleAspectFit : .scaleAspectFill
            }
        })
    }
    
    @IBAction func backBT_Action(_ sender:UIButton!) {
        navigationController?.popViewController(animated: true)
    }
}
