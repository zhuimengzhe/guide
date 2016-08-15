//
//  AVPlayerManager.swift
//  Guide
//
//  Created by OraCleen on 16/4/30.
//  Copyright © 2016年 dingmc. All rights reserved.
//

import UIKit
import AVFoundation
let AVPlayerManagerInstance = AVPlayerManager()
class AVPlayerManager : NSObject {
    private let statusKey = "status"
    private let loadedTimeRangesKey = "loadedTimeRanges"
    private let rateKey = "rate"
    
    var player:AVPlayer!
    //是否正在播放
    var isPlaying = false
    //资源是否完毕
    var isPrepare = false
    
    func initVideoPlayerWithURL(playerUrl:NSURL){
        player = AVPlayer(URL: playerUrl)
        
        player.addObserver(self, forKeyPath: rateKey, options: .New, context: nil)
        //当资源的status发生改变时就会触发观察者事件
        player.currentItem?.addObserver(self, forKeyPath: statusKey, options: .New, context:nil)
        //    加载缓存
        player.currentItem?.addObserver(self, forKeyPath: loadedTimeRangesKey, options:.New ,context: nil)
    }
    
    func getPlayerLayer() -> AVPlayerLayer {
        //创建AVPlayerLayer，必须把视频添加到AVPlayerLayer层，才能播放
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AVPlayerManager.pausePlay), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AVPlayerManager.pausePlay), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AVPlayerManager.startPlay), name: UIApplicationWillEnterForegroundNotification, object: nil)
        //播放完通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AVPlayerManager.MovieFinishedCallback(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player)
    }
    
    //播放一个网络链接音乐
    func musicPlayerWithURL(playerItemURL:NSURL){
        //创建要播放的资源
        let playerItem = AVPlayerItem(URL: playerItemURL)
        //当资源的status发生改变时就会触发观察者事件
        playerItem.addObserver(self, forKeyPath: "status", options: .New, context:nil)
        //播放当前资源
        if player.currentItem != nil {
            //上一首 下一首的实现方式 1
            NSNotificationCenter.defaultCenter().removeObserver(self)
            
            player.replaceCurrentItemWithPlayerItem(playerItem)
            //实现方式2
            //使用AVQueuePlayer的advanceToNextItem
        }
        //加载缓存
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options:.New ,context: nil)
        
        //播放完通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AVPlayerManager.MovieFinishedCallback(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        //添加定时器，更新当前的播放进度
        //        (1）方法传入一个CMTime结构体，每到一定时间都会回调一次，包括开始和结束播放
        //        (2）如果block里面的操作耗时太长，下次不一定会收到回调，所以尽量减少block的操作耗时
        //        (3）方法会返回一个观察者对象，当播放完毕时需要移除这个观察者
        //        let timerObserver = player.addPeriodicTimeObserverForInterval(CMTimeMake(Int64(1),Int32(1)), queue: dispatch_get_main_queue()) { (cmTIme) in
        //            let current = CMTimeGetSeconds(cmTIme)
        //            let total = CMTimeGetSeconds(playerItem.duration)
        //        if current {
        //            progress = current / total
        //        }
        //        }
        //移除观察者
        //if (timeObserve) {
        //        [player removeTimeObserver:_timeObserve];
        //        timeObserve = nil;
        //    }
    }
    func MovieFinishedCallback(notif:NSNotification){
        print(#function)
    }
    
    //播放
    func startPlay(){
        if !isPrepare {
            return
        }
        player.play()
        isPlaying = true
    }
    
    //暂停
    func pausePlay(){
        if !isPlaying {
            return
        }
        player.pause()
        isPlaying = false
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyPath1 = keyPath {
            switch keyPath1 {
            case statusKey:
                //资源观察者
                let status = (change![NSKeyValueChangeNewKey] as! NSNumber).integerValue as AVPlayerStatus.RawValue
                
                switch (status) {
                case AVPlayerStatus.ReadyToPlay.rawValue:
                    isPrepare = true
                    startPlay()
                    print("ready")
                case AVPlayerStatus.Failed.rawValue:
                    print("Failed to load video")
                default:
                    print("default")
                }
            case loadedTimeRangesKey:
                //缓存处理
                let playerItem = object as! AVPlayerItem
                let timeRange = playerItem.loadedTimeRanges.first?.CMTimeRangeValue
                let startSeconds = CMTimeGetSeconds((timeRange?.start)!)
                let durationSeconds = CMTimeGetSeconds((timeRange?.duration)!)
                let totalBuffer = startSeconds + durationSeconds
                print("共缓冲 %.2f",totalBuffer)
            case rateKey:
                print("rate")
            default:
                print("defalut")
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }
    }
}