
import UIKit

class ScenicTableViewCell: UITableViewCell {
    
    var cellView: UIView!
    var imgView: UIImageView!
    
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        cellView = UIView()
        cellView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(cellView)
        //图片
        imgView = UIImageView()
        imgView.image = UIImage(named: "image-bg")
        imgView.setWane(4)
        cellView.addSubview(imgView)
        //标题
        titleLabel = UILabel()
        titleLabel.textColor = Color_333
        titleLabel.font = UIFont.systemFontOfSize(15)
        cellView.addSubview(titleLabel)
        //内容
        contentLabel = UILabel()
        contentLabel.numberOfLines = 2
        contentLabel.textColor = Color_999
        contentLabel.font = UIFont.systemFontOfSize(14)
        cellView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let marginX: CGFloat = 15.Fit6()
    let marginY: CGFloat = 2
    let margin: CGFloat = 10
    
    func setFrameByObject(object: Scenic){
        let cellW: CGFloat = ScreenWidth
        cellView.frame = CGRectMake(0, marginY, cellW, 100)
        //图片
        imgView.frame = CGRectMake(marginX, margin, 80, 80)
        imgView.clipsToBounds = true
        imgView.sd_setImageWithURL(NSURL(string: "\(MainDomain)\(object.logo)"), placeholderImage: UIImage.init(named:object.logo))
        
        let labelX: CGFloat = imgView.endX + margin
        //名称
        titleLabel.frame = CGRectMake(labelX, margin, ScreenWidth - labelX, 20)
        titleLabel.text = object.name
        //内容
        contentLabel.frame = CGRectMake(labelX, titleLabel.endY, cellW-labelX-marginX, 40)
        contentLabel.text = object.summary
        
        frame.size.height = cellView.endY
    }
}