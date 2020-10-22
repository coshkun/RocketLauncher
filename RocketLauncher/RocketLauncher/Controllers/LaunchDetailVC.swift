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
        
        if let i = item {
            // fill-up current data
            missionNameTF.text = i.missionName
            launchSiteTF.text = i.launchSite.siteName
            
            let date = Date(fromString: i.launchDateUTC, withFormat: "yyyy-MM-dd'T'hh:mm:ss.sss'Z'")
            departureTimeTF.text = date.stringDateTimeValue + " in UTC"
            
            detailTX.text = i.details
            
            let placeHolder = UIImage(named: "image_placeholder_640x320")
            guard let link = i.links.flickrImages.first,
                  let url = URL(string: link) else {
                pictureIV.image = placeHolder
                return
            }
            pictureIV.kf.setImage(with: url, placeholder: placeHolder)
            
        }
    }
    
    @IBAction func backBT_Action(_ sender:UIButton!) {
        navigationController?.popViewController(animated: true)
    }
}
