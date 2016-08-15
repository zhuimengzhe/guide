
import UIKit

class MainViewController: BaseViewController{
    
    var mapView: BMKMapView?
    var locationService = BMKLocationService()
    var geocodeSearch = BMKGeoCodeSearch()
    
    var curLocation = CLLocationCoordinate2DMake(39.915, 116.404)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBottomView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = nil
        // TODO: 如果需要自动定位,打开注释即可
        geocodeSearch.delegate = self
        locationService.delegate = self
        mapView?.delegate = self
        mapView?.viewWillAppear()
        
        title = "中国地图".internationByKey("z_g_d_t")
        sinceButton.setTitle("景区选择".internationByKey("select_j_q"), forState: UIControlState.Normal)
        setButton.setTitle("设置".internationByKey("set"), forState: UIControlState.Normal)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationService.delegate = nil
        geocodeSearch.delegate = nil
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
    }
    
    //添加标注
    func addPointAnnotation() {
        
        let   pointAnnotation = BMKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.915, 116.404)
        pointAnnotation.title = "我是pointAnnotation"
        pointAnnotation.subtitle = "此Annotation可拖拽!"
        
        mapView?.addAnnotation(pointAnnotation)
    }
    
    //地图底部
    var bottomView = UIView()
    var setButton = UIButton()
    var sinceButton = UIButton()
    //地图底部
    func initBottomView(){
        locationService.allowsBackgroundLocationUpdates = true
        
        mapView = BMKMapView(frame: CGRectMake(0, 64, ScreenWidth, ScreenHeight - 55.Fit6() - 64))
        mapView?.zoomLevel = 7.0
        //比例尺
        mapView!.showMapScaleBar = true
        mapView!.mapScaleBarPosition = CGPointMake(10, mapView!.frame.height - 50.Fit6())
        view.addSubview(mapView!)
        //定位按钮
        
        let locBtn = UIButton.init(frame: CGRectMake(mapView!.mapScaleBarSize.width + mapView!.mapScaleBarPosition.x + 10, mapView!.endY - 35, 80.Fit6(), 25))
        let img = UIImage.init(named: "bg_yzm")
        locBtn.setBackgroundImage(img, forState: .Normal)
        locBtn.setTitle("我的位置", forState: .Normal)
        locBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        locBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //locBtn.center = CGPointMake(ScreenWidth / 2, locBtn.center.y)
        locBtn.addTarget(self, action: #selector(MainViewController.location), forControlEvents: .TouchUpInside)
        locBtn.layer.cornerRadius = 2;
        view.addSubview(locBtn)
        //放大按钮
        let bigBtn = UIButton.init(frame: CGRectMake(ScreenWidth - 35, mapView!.endY - 65, 25, 25))
        bigBtn.setImage(UIImage(named: "btn_enlarge"), forState: .Normal)
        bigBtn.addTarget(self, action: #selector(MainViewController.enlarg), forControlEvents: .TouchUpInside)
        view.addSubview(bigBtn)
        //缩小按钮
        let sBtn = UIButton.init(frame: CGRectMake(bigBtn.originX,bigBtn.endY + 10,25,25))
        sBtn.setImage(UIImage(named: "btn_lessen"), forState: .Normal)
        sBtn.addTarget(self, action: #selector(MainViewController.smaller), forControlEvents: .TouchUpInside)
        view.addSubview(sBtn)
        //bottomBar
        bottomView.frame = CGRectMake(0, ScreenHeight - 55.Fit6(), ScreenWidth, 55.Fit6())
        bottomView.backgroundColor = Color_mainBg
        view.addSubview(bottomView)
        
        sinceButton.frame = CGRectMake(15, 9.Fit6(), 118.Fit6(), 37.Fit6())
        sinceButton.setBackgroundImage(UIImage.init(named: "bg_jingqu"), forState: .Normal)
        sinceButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        sinceButton.titleLabel?.textAlignment = .Left
        sinceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        sinceButton.addTarget(self, action: #selector(MainViewController.didSinceButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(sinceButton)
        
        setButton.frame = CGRectMake(ScreenWidth - 15 - 79.Fit6(), sinceButton.originY, 79.Fit6(), 37.Fit6())
        setButton.setBackgroundImage(UIImage.init(named: "bg_set"), forState: .Normal)
        setButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        setButton.titleLabel?.textAlignment = .Left
        setButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        setButton.addTarget(self, action: #selector(MainViewController.didSetButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(setButton)
    }
    // MARK: 按钮处理方法
    func location(){
        locationService.startUserLocationService()
        mapView!.showsUserLocation = false//先关闭显示的定位图层
        mapView!.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        mapView!.showsUserLocation = true//显示定位图层
    }
    
    func enlarg(){
        mapView?.zoomLevel += 1
        mapView?.setCenterCoordinate(curLocation, animated: true)
    }
    
    func smaller(){
        mapView?.zoomLevel -= 1
        mapView?.setCenterCoordinate(curLocation, animated: true)
    }
    
    //点击前往设置界面
    func didSetButton(){
        let to_vc = SetViewController()
        self.navigationController?.pushViewController(to_vc, animated: true)
    }
    
    //点击景区选择界面
    func didSinceButton(){
        let to_vc = SegmentViewController()
        to_vc.title = "景区选择".internationByKey("select_j_q")
        self.navigationController?.pushViewController(to_vc, animated: true)
    }
}
// MARK: - BMKMapViewDelegate
extension MainViewController : BMKMapViewDelegate {
    /**
     *当mapView新添加annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 新添加的annotation views
     */
    func mapView(mapView: BMKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        NSLog("didAddAnnotationViews")
    }
    
    /**
     *当选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 选中的annotation views
     */
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        NSLog("选中了标注")
        //TODO:进入景区
    }
    
    /**
     *当取消选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 取消选中的annotation views
     */
    func mapView(mapView: BMKMapView!, didDeselectAnnotationView view: BMKAnnotationView!) {
        NSLog("取消选中标注")
    }
    
    /**
     *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
     *@param mapView 地图View
     *@param view annotation view
     *@param newState 新状态
     *@param oldState 旧状态
     */
    func mapView(mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        NSLog("annotation view state change : \(oldState) : \(newState)")
    }
    
    /**
     *当点击annotation view弹出的泡泡时，调用此接口
     *@param mapView 地图View
     *@param view 泡泡所属的annotation view
     */
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        NSLog("点击了泡泡")
        //TODO:进入景区
    }
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 普通标注
        
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
        
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            // 设置颜色
            annotationView!.pinColor = UInt(BMKPinAnnotationColorPurple)
            // 从天上掉下的动画
            annotationView!.animatesDrop = true
            // 设置可拖曳
            annotationView!.draggable = true
            annotationView!.image = UIImage(named: "icon_postion")
        }
        annotationView?.annotation = annotation
        return annotationView
        
    }
    
}
// MARK: - BMKLocationServiceDelegate
extension MainViewController : BMKLocationServiceDelegate {
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        printLog("willStartLocatingUser");
    }
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        
        mapView!.updateLocationData(userLocation)
        mapView?.userTrackingMode = BMKUserTrackingModeFollow
        curLocation = userLocation.location.coordinate
        mapView?.setCenterCoordinate(userLocation.location.coordinate, animated: true)
        self .reverseGero(userLocation.location.coordinate)
    }
    
    func reverseGero(locatin:CLLocationCoordinate2D){
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = locatin
        
        let flag = geocodeSearch.reverseGeoCode(reverseGeocodeSearchOption)
        if flag {
            printLog("反geo 检索发送成功")
        } else {
            printLog("反geo 检索发送失败")
        }
    }
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        printLog("didStopLocatingUser")
    }
}
// MARK: - BMKGeoCodeSearchDelegate
extension MainViewController : BMKGeoCodeSearchDelegate {
    /**
     *返回反地理编码搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if let mtitle = result.addressDetail.city {
            title = mtitle == "" ? "中国地图".internationByKey("z_g_d_t") : mtitle
        }else{
            title =  "中国地图".internationByKey("z_g_d_t")
        }
    }
}

