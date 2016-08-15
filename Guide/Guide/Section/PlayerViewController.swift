//
//  AVPlayerViewController.swift
//  Guide
//
//  Created by OraCleen on 16/5/2.
//  Copyright © 2016年 dingmc. All rights reserved.
//

import UIKit
import AVFoundation
//import Snappy
class PlayerViewController : BaseViewController {
    
    //private let statusKey = "status"
    //private let loadedTimeRangesKey = "loadedTimeRanges"
    //private let rateKey = "rate"
    
    var zfPlayerView:ZFPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zfPlayerView = ZFPlayerView(frame: view.bounds)
        view.addSubview(zfPlayerView)
        
        
        var url = NSBundle.mainBundle().URLForResource("aaaa", withExtension: "mp4")!
        url = NSURL(string: "http://baobab.wdjcdn.com/1456117847747a_x264.mp4")!
        zfPlayerView.videoURL = url
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        zfPlayerView.hasDownload = true
        
        zfPlayerView.goBackBlock = {
            [unowned self] in
            self.dismissViewControllerAnimated(true, completion: {
                print("video dismiss")
            })
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let width = min(ScreenHeight, ScreenWidth)
        let height = max(ScreenWidth,ScreenHeight)
        let deviceOrientation = UIDevice.currentDevice().orientation
        if deviceOrientation.isPortrait {
            zfPlayerView.frame = CGRectMake(0, 0, width, height)
        }else{
            zfPlayerView.frame = CGRectMake(0, 0, height,width)
        }
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:.Fade)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation:.Fade)
    }
    
    //override func prefersStatusBarHidden() -> Bool {
    //return true
    //}
    //override func preferredStatusBarStyle() -> UIStatusBarStyle {
    //return .LightContent
    //}
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //0.3s
        let width = min(ScreenHeight, ScreenWidth)
        let height = max(ScreenWidth,ScreenHeight)
        
        if toInterfaceOrientation.isPortrait {
            zfPlayerView.frame = CGRectMake(0, 0, width, height)
        }else{
            zfPlayerView.frame = CGRectMake(0, 0, height,width)
        }
    }
    
    deinit{
        zfPlayerView.cancelAutoFadeOutControlBar()
    }
}
extension UIInterfaceOrientation {
    
    func description() -> String {
        switch self {
        case .Unknown:
            return "Unknown"
        case .Portrait:
            return "Portrait"
        case .LandscapeLeft:
            return "LandscapeLeft"
        case .LandscapeRight:
            return "LandscapeRight"
        case .PortraitUpsideDown:
            return "PortraitUpsideDown"
        }
    }
}
