
import UIKit

class ScoreTableViewCell: UITableViewCell {

    var cellView: UIView!
    
    var remarkLabel: UILabel!
    var pointLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.cellView = UIView()
        self.cellView.backgroundColor = UIColor.whiteColor()//.colorWithAlphaComponent(0.7)
        self.contentView.addSubview(self.cellView)
        
        self.remarkLabel = UILabel()
        self.remarkLabel.textColor = Color_333
        self.remarkLabel.font = UIFont.systemFontOfSize(14)
        self.cellView.addSubview(self.remarkLabel)
        
        self.pointLabel = UILabel()
        self.pointLabel.textColor = Color_point
        self.pointLabel.textAlignment = NSTextAlignment.Right
        self.pointLabel.font = UIFont.systemFontOfSize(14)
        self.cellView.addSubview(self.pointLabel)
        
        self.dateLabel = UILabel()
        self.dateLabel.textColor = Color_333
        self.dateLabel.font = UIFont.systemFontOfSize(14)
        self.cellView.addSubview(self.dateLabel)
        
        self.stateLabel = UILabel()
        self.stateLabel.textColor = Color_333
        self.stateLabel.textAlignment = NSTextAlignment.Right
        self.stateLabel.font = UIFont.systemFontOfSize(14)
        self.cellView.addSubview(self.stateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let marginX: CGFloat = 15.Fit6()
    var margin: CGFloat = 7
    func setFrameByObject(score: Score){
        let cellW: CGFloat = UIScreen.mainScreenWidth
        self.cellView.frame = CGRectMake(0, 0, cellW, 70)
        self.remarkLabel.frame = CGRectMake(marginX, margin, cellW/2, 20)
        self.remarkLabel.text = score.remark
        
        self.pointLabel.text = "积分:\(score.balance)"
        self.pointLabel.sizeToFit()
        self.pointLabel.frame = CGRectMake(cellW-marginX-pointLabel.frame.width, margin, pointLabel.frame.width, 20)
        
        self.dateLabel.frame = CGRectMake(marginX, 70-margin-20, cellW-marginX-80, 20)
        self.dateLabel.text = score.createDate
        
        self.stateLabel.frame = CGRectMake(cellW-80-marginX, 70-margin-20, 80, 20)
        self.stateLabel.text = score.state == "2" ? "成功" : "失败"
        
        self.frame.size.height = self.cellView.endY+1
    }
}
