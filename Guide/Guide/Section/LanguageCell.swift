
import UIKit

class LanguageCell: UITableViewCell {

    var nameLabel: UILabel!
    
    var splitLine: LineView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLabel.textColor = selected ? Color_topNav : Color_333
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.whiteColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(nameLabel)
        
        splitLine = LineView()
        contentView.addSubview(splitLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let margin: CGFloat = 10
    
    let marginX: CGFloat = 15.Fit6()
    func setFrameByObject(s: String){
        
        nameLabel.text = s
        nameLabel.frame = CGRectMake(marginX, margin, UIScreen.mainScreenWidth - 2 * marginX, 20)
        
        frame.size.height = nameLabel.endY + margin
        splitLine.frame = CGRectMake(marginX, frame.height-0.5, UIScreen.mainScreenWidth - margin, 0.5)
    }
}
