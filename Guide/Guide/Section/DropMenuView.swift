
import UIKit

protocol DropMenuViewDelegate {
    func didSelectScenic(scenic:Scenic)
}

class DropMenuView: UIView {
    
    var delegate: DropMenuViewDelegate?
    var longestwidth:CGFloat = 80
    var longestCityWidth:CGFloat = 80
    //所有的省
    var cellArray = [City]()
    var provinces = [City]()
    var scenicesArray = [Scenic]()
    var allCities = [String:[[String:String]]]()
    
    var curP: City!
    var curC: City!
    
    var backButton = UIButton()
    lazy var tv: UITableView = {
        var tv = UITableView(frame: CGRectMake(0, self.tableStartY, ScreenWidth / 4, 20))
        tv.backgroundColor = UIColor.whiteColor()
        tv.delegate = self
        tv.dataSource = self
        tv.tag = 0
        
        tv.separatorInset = UIEdgeInsetsZero
        tv.layoutMargins = tv.separatorInset
        tv.separatorStyle = .SingleLine
        tv.sectionIndexBackgroundColor = UIColor.clearColor()
        tv.sectionIndexColor = Color_666
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        
        return tv
    }()
    
    var menuButton1 = MenuButton()
    var menuButton2 = MenuButton()
    var menuButton3 = MenuButton()
    
    lazy var searchButton: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = Color_topNav
        btn.setWane(6)
        btn.setTitle("搜索".internationByKey("s_s"), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.Fit6())
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    //平均分成了4份
    let w: CGFloat = UIScreen.mainScreenWidth / 4
    private let tableStartY = 64 + (38 + 12 + 44).Fit6()
    //初始化
    private func initView(){
        let h = frame.height - 10.Fit6()
        let btnWidth = w - 10.Fit6()
        let margin = 5.Fit6()
        menuButton1.frame = CGRectMake(margin, margin, btnWidth, h)
        menuButton2.frame = CGRectMake(w + margin, margin, btnWidth, h)
        menuButton3.frame = CGRectMake(w * 2 + margin, margin, btnWidth, h)
        
        let font = UIFont.systemFontOfSize(12.Fit6())
        menuButton1.titleLabel?.font = font
        menuButton2.titleLabel?.font = font
        menuButton3.titleLabel?.font = font
        
        menuButton1.curTitle = "省份"
        menuButton2.curTitle = "市级"
        menuButton3.curTitle = "景区名称"
        
        menuButton1.tag = 0
        menuButton1.addTarget(self, action: #selector(DropMenuView.didMenuButton(_:)), forControlEvents: .TouchUpInside)
        
        menuButton2.tag = 1
        menuButton2.addTarget(self, action: #selector(DropMenuView.didMenuButton(_:)), forControlEvents: .TouchUpInside)
        
        menuButton3.tag = 2
        menuButton3.addTarget(self, action: #selector(DropMenuView.didMenuButton(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(menuButton1)
        addSubview(menuButton2)
        addSubview(menuButton3)
        
        searchButton.frame = CGRectMake(w * 3 + margin, margin, btnWidth, h)
        searchButton.addTarget(self, action: #selector(DropMenuView.search(_:)), forControlEvents: .TouchUpInside)
        addSubview(searchButton)
        
        backButton.frame = UIScreen.mainScreenBounds
        backButton.addTarget(self, action: #selector(DropMenuView.didBack), forControlEvents: .TouchUpInside)
        let window: AnyObject? = UIApplication.sharedApplication().windows.last
        window?.addSubview(backButton)
        
        backButton.hidden = true
        backButton.addSubview(tv)
    }
    func search(btn:UIButton){
        let scenic = Scenic(dict: ["ss_id":"test1","ss_name1":"泰山","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"taishan","ss_summary1":"世界文化与自然双重遗产，世界地质公园，全国重点文物保护，位于山东省。。。"])
        delegate?.didSelectScenic(scenic)
    }
    var curMenuTag: Int = 0
    func didMenuButton(btn: UIButton){
        curMenuTag = btn.tag
        
        cellArray.removeAll()
        tv.tag = btn.tag
        
        switch btn.tag{
        case 0:
            //获取省
            getPs(){
                [unowned self] in
                self.backButton.hidden = false
                self.tv.frame = CGRectMake(self.w * CGFloat(btn.tag) + 5.Fit6(), self.tableStartY, self.longestwidth, ScreenHeight - self.tableStartY)
                self.tv.reloadData()
            }
        case 1:
            //获取市
            if curP != nil{
                getCityByProvName(curP.pinyin){
                    [unowned self] in
                    self.backButton.hidden = false
                    self.tv.frame = CGRectMake(self.w * CGFloat(btn.tag) + 5.Fit6(), self.tableStartY, self.longestCityWidth, ScreenHeight - self.tableStartY)
                    self.tv.reloadData()
                }
            }else{
                AlertInstance.showHud(KeyWindow, str: "您还没有选择省")
            }
        case 2:
            scenicesArray.removeAll()
            if curP != nil && curC != nil{
                willOnSearch(){
                    [unowned self] in
                    self.backButton.hidden = false
                    self.tv.frame = CGRectMake(self.w * CGFloat(btn.tag) + 5.Fit6(), self.tableStartY, self.longestCityWidth, ScreenHeight - self.tableStartY)
                    self.tv.reloadData()
                }
            }else{
                AlertInstance.showHud(KeyWindow, str: "您还没有选择省和市")
            }
        default:
            break
        }
    }
    
    func didBack(){
        backButton.hidden = true
    }
    
    func getPs(complete:() -> Void){
        if provinces.count == 0 {
            if let dic = ReadFileUtil.readJsonWithName("city"){
                var longestname = ""
                if let dics = dic["p"] as? [NSDictionary]{
                    //每一个省信息
                    for dic in dics{
                        let city = City(dict: dic)
                        if city.name.characters.count > longestname.characters.count {
                            longestname = city.name
                        }
                        provinces.append(city)
                    }
                    //排序
                    provinces.sortInPlace{
                        $0.pinyin < $1.pinyin
                    }
                }
                
                let cgsize = (longestname as NSString).boundingRectWithSize(CGSizeMake(500, 30.Fit6()), options: [.UsesLineFragmentOrigin,.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
                longestwidth = cgsize.size.width + 20
                //所有的城市
                if let dics = dic["city"] as? [String:[[String:String]]] {
                    self.allCities = dics
                }
            }
        }
        cellArray = provinces
        
        complete()
    }
    
    //根据省获取城市列表
    func getCityByProvName(proname:String,complete:() -> Void){
        //所有的城市
        if let dics = allCities[proname] {
            //每一个省信息
            var longestname = ""
            for dic in dics{
                let city = City(dict: dic)
                
                if city.name.utf8.count > longestname.utf8.count {
                    longestname = city.name
                }
                cellArray.append(city)
            }
            //排序
            cellArray.sortInPlace{
                $0.pinyin < $1.pinyin
            }
            
            let cgsize = (longestname as NSString).boundingRectWithSize(CGSizeMake(500, 30.Fit6()), options: [.UsesLineFragmentOrigin,.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
            longestCityWidth = cgsize.size.width + 20
        }
        //所有的城市
        if cellArray.count > 0 {
            complete()
        }else{
            AlertInstance.showHud(KeyWindow, str: "没有发现子区")
        }
    }
    
    func willOnSearch(complete:() -> Void){
        let parameter = [
            "provinceid"   : curP,
            "city"   : curC,
            "name" : ""
        ]
        
        HttpInstance.requestJSON(.GET, Http_searchscenicspot, parameters: parameter){
            [unowned self] object in
            if let arr = object["scenicspot"] as? [NSDictionary]{
                var longestname = ""
                if arr.count == 0 {
                    if AppTest {
                        for _ in 0...3 {
                            let s = Scenic(dict: ["ss_id":"test1","ss_name1":"泰山","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"taishan","ss_summary1":"世界文化与自然双重遗产，世界地质公园，全国重点文物保护，位于山东省。。。"])
                            let s1 = Scenic(dict: ["ss_id":"test1","ss_name1":"趵突泉","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"baotuquan","ss_summary1":"谈到泉城济南，不得不说的就是济南的趵突泉。济南素以泉水闻名。。。。"])
                            let s2 = Scenic(dict: ["ss_id":"test1","ss_name1":"大明湖公园","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"daminghu","ss_summary1":"风景美丽，文化底蕴深厚，大明湖可以说是济南的文化地标了。。。"])
                            self.scenicesArray.append(s)
                            self.scenicesArray.append(s1)
                            self.scenicesArray.append(s2)
                        }
                        complete()
                    }else{
                        AlertInstance.showHud(KeyWindow, str: "没有获取到景区")
                        self.backButton.hidden = true
                    }
                }else{
                    for dic in arr{
                        let s = City(dict: ["py":"py","name":dic["name"]!])
                        if s.name.utf8.count > longestname.utf8.count {
                            longestname = s.name
                        }
                        self.cellArray.append(s)
                    }
                    let cgsize = (longestname as NSString).boundingRectWithSize(CGSizeMake(500, 30.Fit6()), options: [.UsesLineFragmentOrigin,.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
                    self.longestCityWidth = cgsize.size.width + 20
                    complete()
                }
            }
        }
    }
}

extension DropMenuView: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 2 {
            return scenicesArray.count
        }
        return cellArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 30.Fit6()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell
        if let mycell = tableView.dequeueReusableCellWithIdentifier("cell") {
            cell = mycell
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        if tableView.tag < 2 {
            cell.textLabel?.text = cellArray[indexPath.row].name
        }else{
            
            cell.textLabel?.text = scenicesArray[indexPath.row].name
        }
        cell.separatorInset =  UIEdgeInsetsZero
        cell.layoutMargins = cell.separatorInset
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch curMenuTag{
        case 0:
            curP = cellArray[indexPath.row]
            menuButton1.curTitle = cellArray[indexPath.row].name
        case 1:
            curC = cellArray[indexPath.row]
            menuButton2.curTitle = cellArray[indexPath.row].name
        case 2:
            menuButton3.curTitle = scenicesArray[indexPath.row].name
            delegate?.didSelectScenic(scenicesArray[indexPath.row])
        default:
            print("呵呵,啥都没有哦")
        }
        didBack()
    }
}

