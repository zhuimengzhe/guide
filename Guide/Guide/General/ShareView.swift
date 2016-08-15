
import UIKit

class ShareView: UIView {
    var backView: UIView!
    
    var titleLabel: UILabel!
    var topLine: UIView!
    
    var weichatButton: UIButton!
    var wxfrendsButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: UIScreen.mainScreen().bounds)
    }
    
    private func initBackView(){
        
        let backViewW: CGFloat = frame.width * 4 / 5
        
        backView = UIView()
        backView.frame = CGRectMake(frame.width / 10, (frame.height - 160) / 2, backViewW, 160)
        backView.backgroundColor = UIColor.colorWithHexCode("f9f9f9")
        backView.layer.shadowColor = UIColor.blackColor().CGColor
        backView.clipsToBounds = true
        backView.layer.shadowOpacity = 1
        backView.layer.shadowRadius = 4
        backView.layer.shadowOffset = CGSizeMake(1, 1)
        addSubview(backView)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(10, 0, backViewW - 20, 44)
        titleLabel.font = UIFont.systemFontOfSize(18.Fit6())
        titleLabel.textColor = Color_topNav
        titleLabel.text = "分享到微信或朋友圈"
        titleLabel.textAlignment = .Center
        backView.addSubview(titleLabel)
        
        topLine = UILabel()
        topLine.frame = CGRectMake(0, titleLabel.endY, backViewW, 1.4)
        topLine.backgroundColor = Color_topNav
        backView.addSubview(topLine)
        
        let btnWh: CGFloat = 50
        let wxImageView = UIImageView(frame: CGRectMake((backViewW - 2 * btnWh) / 3,topLine.endY + 10, btnWh, btnWh))
        wxImageView.image = UIImage(named: "wxsession1")
        backView.addSubview(wxImageView)
        
        weichatButton = UIButton(frame:CGRectMake(0,0,20,22))
        weichatButton.setBackgroundImage(UIImage.init(named: "icon_la"), forState: .Normal)
        weichatButton.setImage(UIImage.init(named: "focus"), forState: .Normal)
        weichatButton.setImage(UIImage(named: "focus_on"), forState: .Selected)
        weichatButton.addTarget(self, action: #selector(ShareView.didWeichat), forControlEvents: .TouchUpInside)
        weichatButton.center = CGPointMake(wxImageView.originX - 10 - 5, wxImageView.centerFrameY)
        weichatButton.selected = true
        backView.addSubview(weichatButton)
        
        //微信
        let wx = UILabel(frame:CGRectMake((wxImageView.originX + weichatButton.originX) / 2,wxImageView.endY + 3,wxImageView.endX - weichatButton.originX,10))
        wx.text = "微信"
        wx.textAlignment = .Center
        wx.font = UIFont.systemFontOfSize(10.Fit6())
        wx.sizeFitHeight()
        backView.addSubview(wx)
        
        let wxfriendImageView = UIImageView()
        wxfriendImageView.frame = CGRectMake(wxImageView.endX+(backViewW-2*btnWh)/3, wxImageView.originY, btnWh, btnWh)
        wxfriendImageView.image = UIImage(named: "wxsession1")
        backView.addSubview(wxfriendImageView)
        
        wxfrendsButton = UIButton(frame:CGRectMake(0,0,20,22))
        wxfrendsButton.setBackgroundImage(UIImage.init(named: "icon_la"), forState: .Normal)
        wxfrendsButton.setImage(UIImage.init(named: "focus"), forState: .Normal)
        wxfrendsButton.setImage(UIImage(named: "focus_on"), forState: .Selected)
        wxfrendsButton.center = CGPointMake(wxfriendImageView.originX - wxfrendsButton.bounds.size.width / 2 - 5, weichatButton.center.y)
        wxfrendsButton.addTarget(self, action: #selector(ShareView.didFriends), forControlEvents: .TouchUpInside)
        backView.addSubview(wxfrendsButton)
        
        let wxf = UILabel(frame:CGRectMake((wxfriendImageView.originX + wxfrendsButton.originX) / 2,wx.originY,wx.frameWidth,wx.frameHeight))
        wxf.text = "朋友圈"
        wxf.font = UIFont.systemFontOfSize(10.Fit6())
        wxf.textAlignment = .Center
        backView.addSubview(wxf)
        
        
        let hLabel = UILabel(frame: CGRectMake(0,wxf.endY + 5,backViewW,0.6))
        hLabel.backgroundColor = UIColor.lightGrayColor()
        backView.addSubview(hLabel)
        
        let lastHeight = 160 - hLabel.endY
        let cancelBtn = UIButton(frame:CGRectMake(0,hLabel.endY,backViewW / 2,lastHeight))
        cancelBtn.tag = 1000
        cancelBtn.setTitle("取消".internationByKey("q_x"), forState: .Normal)
        cancelBtn.titleLabel!.font = UIFont.systemFontOfSize(14.Fit6())
        cancelBtn.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        cancelBtn.addTarget(self, action: #selector(ShareView.share(_:)), forControlEvents: .TouchUpInside)
        backView.addSubview(cancelBtn)
        
        let okBtn = UIButton(frame:CGRectMake(backViewW / 2,hLabel.endY,backViewW / 2,lastHeight))
        okBtn.tag = 1001
        okBtn.setTitle("确定".internationByKey("q_d"), forState: .Normal)
        okBtn.titleLabel?.font = cancelBtn.titleLabel?.font
        okBtn.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        okBtn.addTarget(self, action: #selector(ShareView.share(_:)), forControlEvents: .TouchUpInside)
        backView.addSubview(okBtn)
        
        let vLabel = UILabel(frame: CGRectMake(backViewW / 2, hLabel.endY,0.6,lastHeight))
        vLabel.backgroundColor = UIColor.lightGrayColor()
        backView.addSubview(vLabel)
        
        backView.scaleMyView()
    }
    func share(btn:UIButton){
        if btn.tag == 1001 {
            shareToSence(weichatButton.selected ? 0 : 1)
        }
        hide()
    }
    func show(){
        let window: AnyObject? = UIApplication.sharedApplication().windows
        window![1].addSubview(self)
        backView.scaleBigAnimation()
        UIView.animateWithDuration(0.35) { () -> Void in
            self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        }
    }
    
    func didWeichat(){
        weichatButton.selected = true
        wxfrendsButton.selected = false
    }
    
    func didFriends(){
        weichatButton.selected = false
        wxfrendsButton.selected = true
    }
    
    func hide(){
        backView.scaleSmallWithTime(0.35) { () -> Void in
            self.removeFromSuperview()
        }
        UIView.animateWithDuration(0.35) { () -> Void in
            self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        }
    }
    
    func shareToSence(sence: Int){
        
        let ext = WXWebpageObject()
        ext.webpageUrl = "https://itunes.apple.com/us/app/tcs-ai-you-tong/id964376709"
        
        let message = WXMediaMessage()
        message.title = "e伴游-陌生人自由行结伴游同城约会、交友、陪游神器"
        message.description = "e伴游，专业的伴游平台。条件查找适合您的旅游伴侣，发布您的伴游公告，地图查找附近游伴，一步到位。让您的出行不再孤单。"
        message.mediaTagName = "ebanyou"
        message.mediaObject = ext
        
        message.setThumbImage(UIImage(named: "ebanyou.png"))
        let req = SendMessageToWXReq()
        req.message = message
        req.scene = Int32(sence)//0聊天，1朋友圈
        WXApi.sendReq(req)
    }
}
