//
//  AllLaunchesTVCell.swift
//  Rocket Launcher
//
//  Created by Coskun Caner on 22.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import UIKit
import Kingfisher

class AllLaunchesTVCell: UITableViewCell {
    
    @IBOutlet weak var pictureIV:UIImageView!
    @IBOutlet weak var titleLB:UILabel!
    @IBOutlet weak var detailLB:UILabel!
    @IBOutlet weak var dateLB:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            let v = UIView(frame: frame)
            v.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            selectedBackgroundView = v
        } else {
            selectedBackgroundView = nil
        }
    }
    
    var item:Launch! {
        didSet {
            guard item != nil else {return}
            titleLB.text = item.missionName
            detailLB.text = item.details
            
            let date = Date(fromString: item.launchDateUTC, withFormat: "yyyy-MM-dd'T'hh:mm:ss.sss'Z'")
            dateLB.text = date.stringValue //.stringDateTimeValue
            
            // KIGFISHER EXAMPLE
            let imageSize = CGRect(x: 0, y: 0, width: pictureIV.frame.width, height: pictureIV.frame.height)
            if let link = item.links.missionPatch,
               let url = URL(string: link) {
                //let processor = DownsamplingImageProcessor(size: imageSize.size)
                let processor = ResizingImageProcessor(referenceSize: imageSize.size, mode: .aspectFit)
                             //>> RoundCornerImageProcessor(cornerRadius: 20)
                pictureIV.kf.setImage(with: url,
                                      placeholder: UIImage(named: "image_placeholder_640x320"),
                                      options: [.processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage ])

                //imageView.kf.setImage(with: url, placeholder: UIImage(named: "image_placeholder_640x320") )
            }
        }
    }
}

