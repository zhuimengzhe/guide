
import UIKit
import Alamofire

protocol ScenicSelectViewControllerDelegate{
    func willDownload(scenic: Scenic)
}

//景区选择
class ScenicSelectViewController: BaseViewController {
    private let TableView_Province_Tag = 1000
    private let TableView_City_Tag = 1001
    private let TableView_Scenic_Tag = 1002
    
    var delegate: ScenicSelectViewControllerDelegate?
    
    var curProId = "1"
    var curCity = ""
    var curScenic = ""
    
    //所有的省
    var cellArray = [[City]]()
    
    var provinces = [City]()
    
    var sectionTitleArray = [String]()
    
    var allCities = [String:[[String:String]]]()
    //从网络上获取的数据
    var scenicesArray = [Scenic]()
    
    lazy var searchView: DropMenuView = {
        var sv = DropMenuView(frame: CGRectMake(0, 0, ScreenWidth, 44.Fit6()))
        sv.backgroundColor = UIColor.clearColor()
        sv.delegate = self
        return sv
    }()
    
    //tableivew
    lazy var tableview: UITableView = {
        let tv = UITableView(frame: CGRectMake(0, 50.Fit6(), ScreenWidth, self.view.frameHeight - 50.Fit6()),style:.Plain)
        tv.backgroundColor = UIColor.clearColor()
        tv.delegate = self
        tv.dataSource = self
        tv.tag = self.TableView_Province_Tag
        tv.sectionIndexBackgroundColor = UIColor.clearColor()
        tv.sectionIndexColor = Color_666
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        tv.estimatedRowHeight = 40.Fit6()
        tv.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tv)
        return tv
    }()
    
    var curList = "p"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        dispatch_async(GlobalQueue) {
            [unowned self] in
            self.getCellArray()
        }
    }
    
    func refresh(){
        tableview.tag = TableView_Province_Tag
        dispatch_async(GlobalQueue) {
            [unowned self] in
            self.getCellArray()
        }
    }
    
    func getScenic(proviid:String,city:String){
        scenicesArray.removeAll()
        let parameter = [
            "provinceid"   : "山东省",
            "city"   : "泰安市",
            "name" : ""
        ]
        HttpInstance.requestJSON(.GET, Http_searchscenicspot, parameters: parameter){
            [unowned self] object in
            print("景区 \(object)")
            
            if let arr = object["scenicspot"] as? [NSDictionary]{
                print("arr \(arr)")
                if arr.count > 0 {
                    self.tableview.tag = self.TableView_Scenic_Tag
                    for dic in arr{
                        let s = Scenic(dict: dic)
                        self.scenicesArray.append(s)
                    }
                    dispatch_async(GlobalMainQueue) {
                        [unowned self] in
                        self.tableview.reloadData()
                    }
                }else{
                    if AppTest {
                        self.tableview.tag = self.TableView_Scenic_Tag
                        for _ in 0...3 {
                            let s = Scenic(dict: ["ss_id":"test1","ss_name1":"泰山","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"taishan","ss_summary1":"世界文化与自然双重遗产，世界地质公园，全国重点文物保护，位于山东省。。。"])
                            let s1 = Scenic(dict: ["ss_id":"test1","ss_name1":"趵突泉","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"baotuquan","ss_summary1":"谈到泉城济南，不得不说的就是济南的趵突泉。济南素以泉水闻名。。。。"])
                            let s2 = Scenic(dict: ["ss_id":"test1","ss_name1":"大明湖公园","ss_lng":"123.41","ss_lat":"44.242","ss_logo":"daminghu","ss_summary1":"风景美丽，文化底蕴深厚，大明湖可以说是济南的文化地标了。。。"])
                            self.scenicesArray.append(s)
                            self.scenicesArray.append(s1)
                            self.scenicesArray.append(s2)
                        }
                        dispatch_async(GlobalMainQueue) {
                            [unowned self] in
                            self.tableview.reloadData()
                        }
                    }else{
                        AlertInstance.showHud(KeyWindow, str: "没有获取到景区信息☹️")
                    }
                }
            }
        }
    }
    
    //获取省份列表
    func getCellArray(){
        if provinces.count == 0 {
            if let dic = ReadFileUtil.readJsonWithName("city"){
                if let dics = dic["p"] as? [NSDictionary]{
                    //每一个省信息
                    for dic in dics{
                        provinces.append(City(dict: dic))
                    }
                    //排序
                    provinces.sortInPlace{
                        $0.pinyin < $1.pinyin
                    }
                }
                
                //所有的城市
                if let dics = dic["city"] as? [String:[[String:String]]] {
                    allCities = dics
                }
            }
        }
        setSecTitleArray(provinces)
    }
    
    //通过City数组设置titlearray
    func setSecTitleArray(cities:[City]){
        cellArray.removeAll()
        sectionTitleArray.removeAll()
        
        sectionTitleArray.append((cities.first?.getPyCaptain()!)!)
        
        var percellcities = [City]()
        for c in cities{
            let captain = c.getPyCaptain()!
            
            if  !sectionTitleArray.contains(captain) {
                sectionTitleArray.append(captain)
                
                cellArray.append(percellcities)
                
                percellcities = [City]()
                percellcities.append(c)
            }else{
                percellcities.append(c)
            }
        }
        //刷新表格
        dispatch_async(GlobalMainQueue) {
            [unowned self] in
            self.tableview.reloadData()
        }
    }
    
    //根据省获取城市列表
    func getCityByProvName(proname:String){
        var cities = [City]()
        
        if let dics = allCities[proname] {
            //每一个省信息
            for dic in dics{
                cities.append(City(dict: dic))
            }
            //排序
            cities.sortInPlace{
                $0.pinyin < $1.pinyin
            }
        }
        //所有的城市
        if cities.count > 0 {
            self.tableview.tag = TableView_City_Tag
            setSecTitleArray(cities)
        }else{
            AlertInstance.showHud(KeyWindow, str: "没有发现子区")
        }
    }
}

extension ScenicSelectViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.tag == TableView_Scenic_Tag {
            return 1
        }
        return cellArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == TableView_Scenic_Tag {
            return scenicesArray.count
        }
        return cellArray[section].count
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if tableView.tag == TableView_Scenic_Tag{
            return 0
        }
        
        if index == 0 {
            tableView.contentOffset.y = 0
        }else{
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index-1), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        return index
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        if tableView.tag == TableView_Scenic_Tag{
            return nil
        }
        return sectionTitleArray
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if tableView.tag == TableView_Scenic_Tag {
            return 100
        }
        return 35
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView.tag == TableView_Scenic_Tag {
            return 0
        }
        return 28
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == TableView_Scenic_Tag{
            return nil
        }
        return sectionTitleArray[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if tableView.tag == TableView_Scenic_Tag {
            var cell:ScenicTableViewCell!
            if let mycell = tableview.dequeueReusableCellWithIdentifier("ScenicCell") as? ScenicTableViewCell {
                cell = mycell
            }else{
                cell = ScenicTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ScenicCell")
            }
            
            let object = scenicesArray[indexPath.row]
            cell!.setFrameByObject(object)
            return cell!
        }
        
        var cell:UITableViewCell!
        if let mcell = tableview.dequeueReusableCellWithIdentifier("cell") {
            cell = mcell
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = cellArray[indexPath.section][indexPath.row].name
        cell!.textLabel?.textColor = UIColor.colorWithHexCode("336699")
        cell!.textLabel?.font = UIFont.systemFontOfSize(14)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.tableview.tag == TableView_Province_Tag {
            curProId = cellArray[indexPath.section][indexPath.row].name
            getCityByProvName(cellArray[indexPath.section][indexPath.row].pinyin)
        }else if self.tableview.tag == TableView_City_Tag {
            //发送网络请求
            curCity = cellArray[indexPath.section][indexPath.row].name
            getScenic(curProId,city:curCity)
        }else if self.tableview.tag == TableView_Scenic_Tag {
            didGoSpotInfo(scenicesArray[indexPath.row])
        }
    }
    func didGoSpotInfo(scenic:Scenic) {
        let to_vc = ScenicInfoViewController()
        to_vc.scenic = scenic
        print("选中景区 \(scenic)")
        let navi = BaseNavigationViewController(rootViewController: to_vc)
        dispatch_async(GlobalMainQueue) {
            [unowned self] in
            self.presentViewController(navi, animated: true) {
            }
        }
    }
    func willDownLoad(){
        //设置下载路径
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        let parameter = [
            "uid"   : UserInstance.user.id!,
            "sid"   : "f1d43f9728a7413b89edcdfa865e49da",
            "lat" : "35.764148",
            "lng" : "116.82855"
        ]
        
        let download = Alamofire.download(.POST, Http_download, parameters: parameter, destination: destination)
        download.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            
            dispatch_async(dispatch_get_main_queue()) {
                print("Total bytes read on main queue: \(totalBytesRead)")
            }
            }
            .response { _, _, _, error in
                
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Downloaded file successfully")
                }
        }
    }
}
extension ScenicSelectViewController : DropMenuViewDelegate {
    func didSelectScenic(scenic: Scenic) {
        didGoSpotInfo(scenic)
    }
}

