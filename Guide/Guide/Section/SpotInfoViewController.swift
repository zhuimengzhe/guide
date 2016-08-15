//
//  SpotInfoViewController.swift
//  Guide
//
//  Created by apple on 4/29/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
import AVFoundation
class SpotInfoViewController : BaseViewController, McTabBarViewDelegate  {
    var spot:SpotModel!
    var scenic:Scenic!
    var pageControl:UIPageControl!
    var unlessTImer:NSTimer?
    var carousel:iCarousel!
    var progressView:UIProgressView!
    var progressTImer:NSTimer?
    var audioPlayer:AVAudioPlayer?
    var playerButton:UIButton!
    
    private let margin = 5.Fit6()
    private let marginX = 15.Fit6()
    
    let tabBar = McTabBarView()
    private let SpotListTag = 1112
    private let VideoListTag = 1113
    
    let home = McTabBarButton(title: "首页".internationByKey("home_page"), img: UIImage(named: "foot_index"), tag: 0)
    let guide = McTabBarButton(title: "自动导游".internationByKey("automatic_guide"), img: UIImage(named: "foot_dy"), tag: 1)
    
    let goback = McTabBarButton(title: "返回".internationByKey("back"), img: UIImage(named: "foot_back"), tag: 2)
    
    let set = McTabBarButton(title: "设置".internationByKey("set"), img: UIImage(named: "foot_set"), tag: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.whiteColor()
        if AppTest {
            spot = SpotModel(dict: ["sp_id":"sp_id","sp_name1":"孔子六艺城","sp_logo":"logo","sp_img":"img","sp_content1":"孔庙是我国历代封建王朝祭祀春秋时期思想家、政治家、教育家孔子的庙宇，位于曲阜城中央。他是一组具有东方建筑特色、规模宏大，其实宏伟的古代建筑群。\n曲阜孔庙是祭祀孔子的本″，是分布在中国、朝鲜、日本、越南、印度尼西亚、新加坡、美国等国家2000多座孔子庙的显赫和范本，据称孔庙始建于公元前478年，孔子死后第二年（公元前478年）鲁哀公将其顾朝改建为庙。自后历代帝王不断加蜂孔子，扩建庙宇，到清代，邮政地下林大修，扩建成现代规模。秒内共有就进院落，因安倍为中轴，分左、中、右三路，纵长630米，横款140米，有点、糖、谈、个460多件，门房65做，“御碑亭”13座，拥有各种建筑100余座，460余间，占地面积95000平方米的庞大建筑群。空秒内的圣迹殿、十三碑亭及大","sp_lat":"14","sp_lng":"234","sound1":"souncd","video":"微山湖,孔子六艺城,鲁国盛世,金碑亭,孟母林,观水园","addtime":"2016年","ssid":"123"])
            let url = NSBundle.mainBundle().URLForResource("李荣浩-李白", withExtension: "mp3")
            audioPlayer = try! AVAudioPlayer(contentsOfURL: url!)
        }
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        progressTImer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(SpotInfoViewController.soundPro), userInfo: nil, repeats: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //208 64
        let uibutton = UIButton(frame: CGRectMake(0,0,84.Fit6(),28.Fit6()))
        uibutton.setTitle("景点名单", forState: .Normal)
        uibutton.titleLabel?.font = UIFont.systemFontOfSize(12)
        uibutton.layer.borderWidth = 1
        uibutton.backgroundColor = UIColor.clearColor()
        uibutton.layer.borderColor = UIColor.whiteColor().CGColor
        //27 18
        let image = UIImage(named: "xiala2")
        uibutton.setImage(image, forState: .Normal)
        uibutton.addTarget(self, action: #selector(SpotInfoViewController.spots), forControlEvents: .TouchUpInside)
        
        uibutton.horizontalLabelAndImage(4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uibutton)
        
        initView()
        if UserDefaultInstance.boolForKey(ZiDongJiangJieKey) {
            play()
        }
    }
    
    override func enterBack(){
        progressTImer?.fireDate = NSDate.distantFuture()
        unlessTImer?.fireDate = NSDate.distantFuture()
    }
    
    override func enterFront(){
    
        unlessTImer?.fireDate = NSDate.distantPast()
        progressTImer?.fireDate = NSDate.distantPast()
    }
    deinit{
        pause()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func spots(){
        if let v = view.viewWithTag(VideoListTag),video = v as? videoSelectView {
            video.hide(){
                print("视频选择")
            }
        }
        if let lview = view.viewWithTag(SpotListTag),spotview = lview as? SpotListView {
            spotview.hide()
        }else{
            let select = SpotListView(dbsource: scenic)
            select.tag = SpotListTag
            select.delegate = self
            view.addSubview(select)
            view.bringSubviewToFront(select)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        pause()
    }
    func updateUI(){
        guide.footLabel.text = "自动导游".internationByKey("automatic_guide")
        goback.footLabel.text =  "返回".internationByKey("back")
        home.footLabel.text = "首页".internationByKey("home_page")
        set.footLabel.text = "设置".internationByKey("set")
        
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        button.setTitle("景点名单".internationByKey("j_d_m_d"), forState: .Normal)
        
        navigationItem.leftBarButtonItem?.title = spot.name1
        progressView.transform = CGAffineTransformMakeScale(1, 2)
    }

    
    func initView(){
        
        tabBar.delegate = self
        tabBar.frame = CGRectMake(0, ScreenHeight - 60.Fit6(), ScreenWidth, 60.Fit6())
        tabBar.backgroundColor = Color_eee
        tabBar.setTabButton([home,guide, goback, set])
        view.addSubview(tabBar)
        
        carousel = iCarousel(frame:CGRectMake(0,0,ScreenWidth,294.Fit6()))
        carousel.delegate = self
        carousel.type = .Linear
        carousel.dataSource = self
        carousel.pagingEnabled = true
        view.addSubview(carousel)
        
        //dingshiqi
        pageControl = UIPageControl(frame: CGRectMake(0,carousel.frameHeight - 20,carousel.frameWidth,20))
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor ( red: 0.7569, green: 0.7569, blue: 0.7569, alpha: 1.0 )
        pageControl.currentPageIndicatorTintColor = UIColor ( red: 0.1294, green: 1.0, blue: 1.0, alpha: 1.0 )
        pageControl.hidesForSinglePage = true
        carousel.addSubview(pageControl)
        
        unlessTImer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(roll), userInfo: nil, repeats: true)
        
        //播放按钮
        playerButton = UIButton()
        playerButton.frame = CGRectMake(marginX, carousel.endY + margin, 22.Fit6(), 22.Fit6())
        playerButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
        playerButton.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Selected)
        playerButton.addTarget(self, action: #selector(SpotInfoViewController.didPlayerButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(playerButton)
        
        progressView = UIProgressView()
        progressView.progressImage = UIImage(named: "bg_jd02")
        progressView.trackImage = UIImage(named: "bg_jd01")
        view.addSubview(progressView)
        progressView.frame = CGRectMake(playerButton.endX + margin, playerButton.originY + playerButton.boundsHeight / 2, ScreenWidth - playerButton.endX - margin - marginX, 20.Fit6())
        
        //景点视频播放按钮
        let videoButton = UIButton()
        videoButton.frame = CGRectMake(ScreenWidth - marginX - 32.Fit6(),playerButton.endY + margin, 32.Fit6(), 32.Fit6())
        videoButton.setBackgroundImage(UIImage(named: "video"), forState: UIControlState.Normal)
        videoButton.addTarget(self, action: #selector(SpotInfoViewController.didVideoButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(videoButton)
        
        let videoLabel = UILabel(frame:CGRectMake(marginX,videoButton.originY,ScreenWidth - marginX * 2 - margin - videoButton.frameWidth,videoButton.frameHeight))
        
        videoLabel.text = "景点视频"
        videoLabel.textColor = Color_333
        videoLabel.font = UIFont.systemFontOfSize(15.Fit6())
        videoLabel.textAlignment = NSTextAlignment.Right
        view.addSubview(videoLabel)
        
        let grayLabel = UILabel(frame: CGRectMake(0,videoLabel.endY + margin,ScreenWidth,margin))
        grayLabel.backgroundColor = UIColor ( red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0 )
        view.addSubview(grayLabel)
        
        let textView = UITextView(frame: CGRectMake(margin, grayLabel.endY + margin, ScreenWidth - 2 * margin, ScreenHeight - grayLabel.endY - margin - 60.Fit6() - 20.Fit6()))
        textView.alwaysBounceVertical = true
        textView.editable = false
        textView.showsVerticalScrollIndicator = false
        textView.textColor = Color_333
        textView.font = UIFont.systemFontOfSize(14)
        textView.text = spot.content1
        view.addSubview(textView)
        
        let downgrayLabel = UILabel(frame:CGRectMake(0,ScreenHeight - 80.Fit6(),ScreenWidth,20.Fit6()))
        downgrayLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        view.addSubview(downgrayLabel)
    }
    
    func roll(){
        carousel.scrollByNumberOfItems(1, duration: 1)
    }
    
    func soundPro(){
        if let player = audioPlayer {
            if player.playing {
                progressView.progress = Float(player.currentTime / player.duration)
            }
        }else{
            progressTImer?.invalidate()
        }
    }
    
    func didPlayerButton(btn:UIButton) {
        btn.selected = !btn.selected
        if btn.selected {
            play()
        }else{
            pause()
        }
    }
    
    //播放
    func play(){
        playerButton.selected = true
        audioPlayer?.play()
    }
    
    //播放视频
    func pause(){
        playerButton.selected = false
        audioPlayer?.pause()
    }
    
    func didVideoButton(btn:UIButton){
        let select = videoSelectView(dbsource: scenic)
        select.tag = VideoListTag
        select.delegate = self
        view.addSubview(select)
        view.bringSubviewToFront(select)
    }
    //McTabBarViewDelegate
    func didTabBarByTag(mcTabBarView: McTabBarView, tag: Int) {
        print(tag)
        switch tag{
        case 0:
            //首页
            navigationController?.popToRootViewControllerAnimated(true)
            break
        case 1:
            //自动导游
            break
        case 2:
            //返回
            navigationController?.popViewControllerAnimated(true)
        case 3:
            //设置
            let to_vc = SetViewController()
            navigationController?.pushViewController(to_vc, animated: true)
        default:
            print("\(#file)")
        }
    }
}

extension SpotInfoViewController : AVAudioPlayerDelegate {
    
}
extension SpotInfoViewController : SpotListViewSelectProtocol {
    func didSelectSpot(spot:String) {
        
    }
}
extension SpotInfoViewController : VideoSelectProtocol {
    func didSelectVideo(videoName:String){
        //播放视频
         pause()
        let av = PlayerViewController()
        presentViewController(av, animated: true, completion: nil)
    }
}
extension SpotInfoViewController : iCarouselDelegate {
    
    func carousel(carousel: iCarousel,valueForOption option:iCarouselOption,withDefault value:CGFloat) -> CGFloat {
        if option == .Wrap {
            return 1.0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        print("select \(index)")
    }

    func carouselWillBeginDragging(carousel:iCarousel) {
        print(#function)
        unlessTImer?.fireDate = NSDate.distantFuture()
        
    }
    func carouselDidEndDecelerating(carousel: iCarousel) {
        print(#function)
        unlessTImer?.fireDate = NSDate.distantPast()
    }
}

extension SpotInfoViewController : iCarouselDataSource {
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return 3
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let imagename = ["first.jpg","second.jpg","third.jpg"]
        
        if AppTest {
            if let imagev = view as? UIImageView {
                imagev.image = UIImage(named:imagename[index])
            }else{
                let imagevv = UIImageView(frame:carousel.bounds)
                imagevv.image = UIImage(named:imagename[index])
                return imagevv
            }
        }
        return UIView()
    }
}
