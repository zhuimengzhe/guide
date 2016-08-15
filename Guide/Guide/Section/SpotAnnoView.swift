//
//  SpotAnnoView.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.

import UIKit

class SpotAnnoView : BMKAnnotationView {
    
    var spotLabel:UILabel!
    var spotImageView:UIImageView!
    
    override init(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        bounds = CGRectMake(0, 0, 80.Fit6(), 32.5.Fit6())
        backgroundColor = UIColor.clearColor()
        //45 * 64
        spotImageView = UIImageView(frame: CGRectMake(0, 0, 22.5.Fit6(), 32.5.Fit6()))
        addSubview(spotImageView)
        
        spotLabel = UILabel(frame: CGRectMake(25.Fit6(),0,55.Fit6(),bounds.height))
        spotLabel.font = UIFont.systemFontOfSize(14.Fit6())
        spotLabel.backgroundColor = UIColor.whiteColor()
        spotLabel.textAlignment = .Center
        spotLabel.textColor = UIColor.blackColor()
        addSubview(spotLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSpotImage(image:UIImage) {
        spotImageView.image = image
    }
    func setSpotName(name:String) {
        spotLabel.text = name
    }
}