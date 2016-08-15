
import UIKit
import AVFoundation

class ScenicInfoViewController: BaseViewController, McTabBarViewDelegate {
    
    let tabBar = McTabBarView()
    let guide = McTabBarButton(title: "自动导游".internationByKey("automatic_guide"), img: UIImage(named: "foot_dy"), tag: 0)
    let select = McTabBarButton(title: "景区选择".internationByKey("select_scenic_area"), img: UIImage(named: "foot_jq"), tag: 1)
    let buy = McTabBarButton(title: "购买".internationByKey("buy"), img: UIImage(named: "foot_buy"), tag: 2)
    let set = McTabBarButton(title: "设置".internationByKey("set"), img: UIImage(named: "foot_set"), tag: 3)
    
    var scenic: Scenic!
    var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    var playerButton: UIButton!
    var playerLabel:UILabel!
    var videoLabel:UILabel!
    var scenicLable:UILabel!
    
    var audioPlayer:AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置听筒还是扩音器
        if UserDefaultInstance.boolForKey(ShouTingFangShiKey) {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }else{
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        
        if AppTest {
            UIDevice.currentDevice().proximityMonitoringEnabled  = true
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ScenicInfoViewController.sensorStateChnage(_:)), name: UIDeviceProximityStateDidChangeNotification, object: nil)
            scenic = Scenic(dict: ["ss_id":"test1","ss_name1":"孔庙","ss_lng":"116.404","ss_lat":"39.915","ss_logo":"ltestogo","ss_summary1":"灵岩寺旅游区位于济南市长清区万德镇境内，所处的这座秀丽的山峦，名叫灵岩山，是东岳泰山十二支脉之一。\n主峰狮山海拔687.3米，从远处望去，犹如一头雄师蹲伏在那里，因而得名。山的最高处有一巨大岩石，四壁如削，最早称为“方山”。 北魏时《水经注》中称它为“玉符山”，是因为这块巨石的形状方方正正，就像古代将军的玉玺，古代将军印叫“玉符”，所以得名。\n灵岩寺历史悠久，早在1600多年前，这里就有寺院。传说东晋高僧郎公来此说法，因他讲的非常生动，以至于“猛兽归服，乱石点头”。有人告诉郎公，郎公说“此山灵也，不足为怪”，因此而得名灵岩。北魏正光年间（520年）法定禅师重建寺院，先在方山之阴建了一座神宝寺，后来又迁到了方山之阳、甘露泉的西边，始称“灵岩寺”。\n唐贞观年间，高僧慧崇又将寺迁到现在的位置。后来又经过几次扩建，形成了现在的规模，灵岩的名字也一直沿用到今天。灵岩寺处在一山（泰山）、一水（济南的泉水）、一圣人（曲阜的孔子）山东黄金旅游线路之间，（距泰山主峰约为10公里，距济南40余公里）以其优美的自然景观和灿烂的古代文化，吸引无数海内外游人，自古就是闻名的旅游胜地，唐朝时香火最盛，有“海内四大名刹之首” 的盛名。其它三寺分别是浙江天台国清寺、湖北江陵玉泉寺、江苏南京栖霞寺。"])
            scenic.video = "视频名称1,视频名称2,视频名称3,视频名称4,视频名称5"
            let url = NSBundle.mainBundle().URLForResource("李翊君-永远永远", withExtension: "mp3")
            audioPlayer = try! AVAudioPlayer(contentsOfURL: url!)
        }
        //path += "/scenicListFloder/\(scenic.id!)"
        
        //FilePathController.renameFileByPath(path, oldName: "soundchinese.mp1", newName: "soundchinese.mp3")
        //do {
        //try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path+"/soundchinese.mp3"))
        //}catch{
        //print("播放失败了...")
        //}
        initView()
        if UserDefaultInstance.boolForKey(ZiDongJiangJieKey) {
            playerButton.selected = true
            play()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        pause()
        navigationController?.navigationBarHidden = false
    }
    
    func updateUI(){
        guide.footLabel.text = "自动导游".internationByKey("automatic_guide")
        select.footLabel.text =  "景区选择".internationByKey("select_scenic_area")
        buy.footLabel.text = "购买".internationByKey("buy")
        set.footLabel.text = "设置".internationByKey("set")
        playerLabel.text = "语音讲解".internationByKey("language_j_j")
        videoLabel.text = "景区视频".internationByKey("j_q_s_p")
        scenicLable.text = scenic.name
    }
    override func enterBack(){
        if UserDefaultInstance.boolForKey(ZiDongJiangJieKey) {
            play()
        }
    }
    
    override func enterFront(){
        pause()
    }
    
    deinit {
        if AppTest {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceProximityStateDidChangeNotification, object: nil)
            ////如果播放完毕
            UIDevice.currentDevice().proximityMonitoringEnabled = false
        }
    }
    
    func sensorStateChnage(notification:NSNotificationCenter){
        if UIDevice.currentDevice().proximityState {
            //黑屏
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }else{
            //没有黑屏
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
    }
    
    func initView(){
        //下面的东东？？？
        let topBarView = UIView()
        tabBar.delegate = self
        tabBar.frame = CGRectMake(0, ScreenHeight - 60.Fit6(), ScreenWidth, 60.Fit6())
        tabBar.backgroundColor = Color_eee
        tabBar.setTabButton([guide, select, buy, set])
        view.addSubview(tabBar)
        
        //状态栏的类似的一个背景
        topBarView.frame = CGRectMake(0, 0, ScreenWidth, 20)
        topBarView.backgroundColor = Color_topNav
        view.addSubview(topBarView)
        
        //景区图
        let imgViewBtn = UIButton()
        imgViewBtn.frame = CGRectMake(0, 20, ScreenWidth, 180.Fit6())
        
        imgViewBtn.setImage(UIImage(contentsOfFile: "\(path)/logo.jpg"), forState: .Normal)
        imgViewBtn.setImage(UIImage(contentsOfFile: "\(path)/logo.jpg"), forState: .Highlighted)
        if AppTest {
            imgViewBtn.setImage(UIImage(named: "aaaa"), forState: .Normal)
            imgViewBtn.setImage(UIImage(named: "aaaa"), forState: .Highlighted)
        }
        imgViewBtn.addTarget(self, action: #selector(ScenicInfoViewController.imageTap), forControlEvents: .TouchUpInside)
        view.addSubview(imgViewBtn)
        
        scenicLable = UILabel(frame: CGRectMake(0,imgViewBtn.bounds.height - 40.Fit6(),imgViewBtn.bounds.width,40.Fit6()))
        scenicLable.textColor = UIColor.whiteColor()
        scenicLable.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        scenicLable.textAlignment = .Center
        //景区名称
        scenicLable.text = scenic.name
        imgViewBtn.addSubview(scenicLable)
        
        //语音讲解和景区视频
        let imgBH: CGFloat = 48.Fit6()
        let imgBottomView = UIView()
        imgBottomView.frame = CGRectMake(0, imgViewBtn.endY, ScreenWidth, imgBH)
        imgBottomView.backgroundColor = UIColor.whiteColor()
        view.addSubview(imgBottomView)
        
        let w = ScreenWidth / 2 - 64
        playerLabel = UILabel()
        playerLabel.frame = CGRectMake(15.Fit6(),0, w,imgBH)
        playerLabel.text = "语音讲解".internationByKey("language_j_j")
        playerLabel.textColor = Color_333
        playerLabel.font = UIFont.systemFontOfSize(15.Fit6())
        playerLabel.sizeFitWidth()
        imgBottomView.addSubview(playerLabel)
        
        //播放按钮
        playerButton = UIButton()
        playerButton.frame = CGRectMake(playerLabel.endX + 5, 8.Fit6(), 32.Fit6(), 32.Fit6())
        playerButton.setBackgroundImage(UIImage(named: "no_voice"), forState: UIControlState.Normal)
        playerButton.setBackgroundImage(UIImage(named: "voice"), forState: UIControlState.Selected)
        playerButton.addTarget(self, action: #selector(ScenicInfoViewController.didPlayerButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        imgBottomView.addSubview(playerButton)
        
        //景区视频的label
        videoLabel = UILabel()
        videoLabel.frame = CGRectMake(ScreenWidth / 2 + 10.Fit6(),0, w,imgBH)
        videoLabel.text = "景区视频"
        videoLabel.textColor = Color_333
        videoLabel.font = UIFont.systemFontOfSize(15.Fit6())
        videoLabel.textAlignment = NSTextAlignment.Right
        imgBottomView.addSubview(videoLabel)
        
        //景区视频播放按钮
        let videoButton = UIButton()
        videoButton.frame = CGRectMake(ScreenWidth - 15 - 32.Fit6(), 8.Fit6(), 32.Fit6(), 32.Fit6())
        videoButton.setBackgroundImage(UIImage(named: "video"), forState: UIControlState.Normal)
        videoButton.addTarget(self, action: #selector(ScenicInfoViewController.didVideoButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        imgBottomView.addSubview(videoButton)
        
        //景区介绍
        let introTitleLabel = UILabelPadding()
        introTitleLabel.frame = CGRectMake(0, imgBottomView.endY+10.Fit6(), ScreenWidth, 40.Fit6())
        introTitleLabel.backgroundColor = UIColor.whiteColor()
        introTitleLabel.textColor = Color_666
        introTitleLabel.paddingLeft = 15
        introTitleLabel.font = UIFont.systemFontOfSize(14)
        introTitleLabel.text = "景区介绍".internationByKey("scen_j_s")
        view.addSubview(introTitleLabel)
        
        //整体内容
        let textView = UITextView(frame: CGRectMake(0, introTitleLabel.endY, ScreenWidth, tabBar.originY - introTitleLabel.endY))
        textView.alwaysBounceVertical = true
        textView.editable = false
        textView.showsVerticalScrollIndicator = false
        textView.textColor = Color_333
        textView.font = UIFont.systemFontOfSize(14)
        textView.text = scenic.summary
        
        view.addSubview(textView)
    }
    //点击图片
    func imageTap(){
        let to_vc = ScenicMapViewController()
        to_vc.scenic = scenic
        navigationController?.pushViewController(to_vc, animated: true)
    }
    
    func didVideoButton(btn:UIButton){
        //视频播放
        let select = videoSelectView(dbsource: scenic)
        select.delegate = self
        view.addSubview(select)
        view.bringSubviewToFront(select)
    }
    
    //音频播放按钮
    func didPlayerButton(btn:UIButton){
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
    
    //McTabBarViewDelegate
    func didTabBarByTag(mcTabBarView: McTabBarView, tag: Int) {
        print(tag)
        switch tag{
        case 0:
            //自动导游
            break
        case 1:
            //景区选择
            dismissViewControllerAnimated(true, completion: nil)
            break
        case 2:
            //购买
            let to_vc = SegmentViewController()
            navigationController?.pushViewController(to_vc, animated: true)
            break
        case 3:
            //设置
            let to_vc = SetViewController()
            navigationController?.pushViewController(to_vc, animated: true)
            break
        default:
            break
        }
    }
}

extension ScenicInfoViewController : VideoSelectProtocol {
    func didSelectVideo(video: String) {
        //播放视频
        let av = PlayerViewController()
        presentViewController(av, animated: true, completion: nil)
        
    }
}
