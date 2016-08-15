
import UIKit

class DownloadingTableViewCell: UITableViewCell {

    var cellView: UIView!
    var nameLabel: UILabel!
    var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.cellView = UIView()
        self.cellView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(self.cellView)
        
        //标题
        self.nameLabel = UILabel()
        self.nameLabel.textColor = Color_333
        self.nameLabel.font = UIFont.systemFontOfSize(15)
        self.cellView.addSubview(self.nameLabel)
        
        self.progressView = UIProgressView()
        self.progressView.trackTintColor = Color_999
        self.progressView.tintColor = Color_topNav
        self.cellView.addSubview(self.progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let marginX: CGFloat = 15.Fit6()
    let marginY: CGFloat = 2
    let margin: CGFloat = 10
    func setFrameByObject(object: DownloadScenic){
        let cellW: CGFloat = UIScreen.mainScreenWidth
        self.cellView.frame = CGRectMake(0, marginY, cellW, 80)
        
        self.nameLabel.frame = CGRectMake(marginX, margin, UIScreen.mainScreenWidth-marginX*2, 20)
        self.nameLabel.text = object.scenic.name
        
        self.progressView.frame = CGRectMake(marginX, self.nameLabel.endY+margin, UIScreen.mainScreenWidth-marginX*2, 10)
        self.progressView.setProgress(object.progress, animated: false)
        
        self.frame.size.height = self.cellView.endY
    }
}
