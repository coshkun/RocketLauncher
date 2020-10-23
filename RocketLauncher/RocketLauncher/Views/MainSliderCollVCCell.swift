//
//  MainSliderCollVCCell.swift
//  Rocket Launcher
//
//  Created by Coskun Caner on 23.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import UIKit

class MainSliderCollVCCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureIV:UIImageView!
    @IBOutlet weak var titleLB:UILabel!
    @IBOutlet weak var dateLB:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var item:Launch! {
        didSet {
            guard item != nil else {return}
            titleLB.text = item.missionName
            
            let date = Date(fromString: item.launchDateUTC, withFormat: "yyyy-MM-dd'T'hh:mm:ss.sss'Z'")
            dateLB.text = date.stringDateTimeValue + " UTC"
            
            let placeHolder = UIImage(named: "image_placeholder_640x320") // Use Dummy Image: rocket-launch-67723
            guard let link = item.links.flickrImages.first,
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
    }
}
