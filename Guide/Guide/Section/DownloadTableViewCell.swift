
import UIKit
protocol DownloadCellProtocol {
    func didSelectCell(cellIndex:Int)
    
    func buyBtnClicked(cellIndex:Int)
    func inBtnClicked(cellIndex:Int)
    func deleteBtnClicked(cellIndex:Int)
}

class DownloadTableViewCell: UITableViewCell {
    
    //var cellView: UIView!
    //景区图
    var imgView: UIImageView!
    //标题
    var titleLabel: UILabel!
    //是否下载
    var isDownloadLabel: UILabel!
    //内容
    var contentLabel: UILabel!
    //进度条
    var progressView: UIProgressView!
    //进度描述
    var progressLabel: UILabel!
    
    var buyButton: UIButton!
    var inButton: UIButton!
    var deleteButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        //cellView = UIView()
        //cellView.backgroundColor = UIColor.whiteColor()
        //contentView.addSubview(cellView)
        
        //景区图片
        imgView = UIImageView()
        imgView.image = UIImage(named: "image-bg")
        imgView.setWane(4)
        contentView.addSubview(imgView)
        
        //景区标题
        titleLabel = UILabel()
        titleLabel.textColor = Color_333
        titleLabel.textAlignment = .Left
        titleLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(titleLabel)
        
        //是否下载状态
        isDownloadLabel = UILabel()
        isDownloadLabel.textColor = UIColor.orangeColor()
        isDownloadLabel.font = UIFont.systemFontOfSize(14)
        isDownloadLabel.textAlignment = .Right
        contentView.addSubview(isDownloadLabel)
        
        //景区简介
        contentLabel = UILabel()
        contentLabel.numberOfLines = 2
        contentLabel.textColor = Color_999
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(contentLabel)
        
        //进度条
        
        progressView = UIProgressView()
        
        progressView.progressImage = UIImage(named: "bg_jd02")
        progressView.trackImage = UIImage(named: "bg_jd01")
        contentView.addSubview(progressView)
        
        //进度百分比
        progressLabel = UILabel()
        progressLabel.textColor = Color_progress
        progressLabel.font = UIFont.systemFontOfSize(14)
        progressLabel.textAlignment = .Right
        contentView.addSubview(progressLabel)
        
        //购买按钮
        buyButton = UIButton()
        buyButton.setTitle("购买".internationByKey("buy"), forState: UIControlState.Normal)
        buyButton.addTarget(self, action: #selector(DownloadTableViewCell.buy(_:)), forControlEvents: .TouchUpInside)
        buyButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        buyButton.backgroundColor = UIColor.redColor()
        contentView.addSubview(buyButton)
        
        //进入按钮
        inButton = UIButton()
        inButton.setTitle("进入".internationByKey("get_into"), forState: UIControlState.Normal)
        inButton.addTarget(self, action: #selector(DownloadTableViewCell.enter(_:)), forControlEvents: .TouchUpInside)
        inButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        inButton.backgroundColor = UIColor.orangeColor()
        contentView.addSubview(inButton)
        
        //删除按钮
        deleteButton = UIButton()
        deleteButton.setTitle("删除", forState: UIControlState.Normal)
        deleteButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        deleteButton.addTarget(self, action: #selector(DownloadTableViewCell.deleteClicked(_:)), forControlEvents: .TouchUpInside)
        deleteButton.backgroundColor = Color_topNav
        contentView.addSubview(deleteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buy(btn:UIButton){
        print("购买")
    }
    
    func enter(btn:UIButton){
        print("进入")
    }
    
    func deleteClicked(btn:UIButton){
        print("删除")
    }
    
    let marginX: CGFloat = 15.Fit6()
    let marginY: CGFloat = 2.Fit6()
    let margin: CGFloat = 10.Fit6()
    
    func setFrameByObject(object: Scenic){
        let cellW: CGFloat = ScreenWidth
        //contentView.frame = CGRectMake(0, marginY, cellW, 100.Fit6())
        
        imgView.frame = CGRectMake(marginX, margin, 80.Fit6(), 80.Fit6())
        imgView.sd_setImageWithURL(NSURL(string: "\(MainDomain)\(object.logo)"), placeholderImage: UIImage(named: "image-bg"))
        
        let labelX: CGFloat = imgView.endX + margin
        //标题
        titleLabel.frame = CGRectMake(labelX, margin, cellW - labelX, 20.Fit6())
        titleLabel.text = object.name
        //内容
        contentLabel.frame = CGRectMake(labelX, titleLabel.endY + marginY, cellW - labelX - marginX, 40.Fit6())
        contentLabel.text = object.summary
        //状态
        isDownloadLabel.frame = CGRectMake(cellW - 60.Fit6() - marginX, titleLabel.originY, 60.Fit6(), titleLabel.frameHeight)
        isDownloadLabel.text = "已下载"
        
        progressLabel.frame = CGRectMake(cellW - 15.Fit6(), contentLabel.endY + marginY, 60.Fit6(), 15.Fit6())
        progressLabel.text = "20%"
        progressLabel.sizeToFit()
        let frmae = progressLabel.frame
        progressLabel.frame = CGRectMake(cellW - frmae.width - marginX, contentLabel.endY + marginY, frmae.width, frmae.height)
        //153 11
        progressView.frame = CGRectMake(contentLabel.originX, progressLabel.originY + progressLabel.frameHeight / 3, progressLabel.originX - contentLabel.originX - marginY, 23.Fit6())
        progressView.progress = 0.2
        progressView.transform = CGAffineTransformMakeScale(1, 3)
        
        //删除按钮 72 30
        let btnW = 72.Fit6() , btnH = 32.Fit6()
        deleteButton.frame = CGRectMake(cellW - marginX - btnW, progressLabel.endY + marginY, btnW, btnH)
        
        //进去
        inButton.frame = CGRectMake(deleteButton.originX - marginX - btnW, deleteButton.originY, btnW, btnH)
        
        //购买
        buyButton.frame = CGRectMake(inButton.originX - marginX - btnW, deleteButton.originY, btnW, btnH)
        
        frame.size.height = CGRectGetMaxY(buyButton.frame) + margin
    }
}
