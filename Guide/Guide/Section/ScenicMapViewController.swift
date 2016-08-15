//
//  ScenicMapViewController.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.
//
import UIKit

class ScenicMapViewController : BaseViewController, McTabBarViewDelegate {
    
    var scenic: Scenic!
    var mapView: BMKMapView?
    let tabBar = McTabBarView()
    private let ListViewTag = 1112
    
    let home = McTabBarButton(title: "首页".internationByKey("home_page"), img: UIImage(named: "foot_index"), tag: 0)
    let guide = McTabBarButton(title: "自动导游".internationByKey("automatic_guide"), img: UIImage(named: "foot_dy"), tag: 1)
    
    let select = McTabBarButton(title: "景区选择".internationByKey("select_scenic_area"), img: UIImage(named: "foot_jq"), tag: 2)
    
    let set = McTabBarButton(title: "设置".internationByKey("set"), img: UIImage(named: "foot_set"), tag: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //208 64
        let uibutton = UIButton(frame: CGRectMake(0,0,84.Fit6(),28.Fit6()))
        uibutton.setTitle("景点名单", forState: .Normal)
        uibutton.titleLabel?.font = UIFont.systemFontOfSize(12)
        uibutton.layer.borderWidth = 1
        uibutton.backgroundColor = UIColor.clearColor()
        uibutton.layer.borderColor = UIColor.whiteColor().CGColor
        //27 18
        let image = UIImage(named: "xiala2")
        uibutton.setImage(image, forState: .Normal)
        uibutton.addTarget(self, action: #selector(ScenicMapViewController.spots), forControlEvents: .TouchUpInside)
        
        uibutton.horizontalLabelAndImage(4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uibutton)
        
        initView()
    }
    func spots(){
        if let lview = view.viewWithTag(ListViewTag),spotview = lview as? SpotListView {
            spotview.hide()
        }else{
            scenic.video = "微山湖,孔子六艺城,鲁国盛世,金碑亭,孟母林,观水园"
            let select = SpotListView(dbsource: scenic)
            select.tag = ListViewTag
            select.delegate = self
            view.addSubview(select)
            view.bringSubviewToFront(select)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        mapView?.delegate = self
        mapView?.viewWillAppear()
        
        addAnnotation()
    }
    func updateUI(){
        guide.footLabel.text = "自动导游".internationByKey("automatic_guide")
        select.footLabel.text =  "景区选择".internationByKey("select_scenic_area")
        home.footLabel.text = "首页".internationByKey("home_page")
        set.footLabel.text = "设置".internationByKey("set")
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        button.setTitle("景点名单".internationByKey("j_d_m_d"), forState: .Normal)
        navigationItem.leftBarButtonItem?.title = scenic.name
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
    }
    
    func initView(){
        //下面的东东？？？
        tabBar.delegate = self
        tabBar.frame = CGRectMake(0, ScreenHeight - 60.Fit6(), ScreenWidth, 60.Fit6())
        tabBar.backgroundColor = Color_eee
        tabBar.setTabButton([home,guide, select, set])
        view.addSubview(tabBar)
        
        mapView = BMKMapView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60.Fit6()))
        mapView?.zoomLevel = 14.0
        
        view.addSubview(mapView!)
    }
    //根据scenic 添加 annotationview
    func addAnnotation(){
        let annotation = BMKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(scenic.lat)!,CLLocationDegrees(scenic.lng)!)
        annotation.title = scenic.name
        mapView?.addAnnotation(annotation)
    }
    
    //McTabBarViewDelegate
    func didTabBarByTag(mcTabBarView: McTabBarView, tag: Int) {
        print(tag)
        switch tag{
        case 0:
            //首页
            navigationController?.popToRootViewControllerAnimated(true)
            break
        case 1:
            //自动导游
            break
        case 2:
            //景区选择
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        case 3:
            //设置
            let to_vc = SetViewController()
            navigationController?.pushViewController(to_vc, animated: true)
        default:
            print("\(#file)")
        }
    }
}
extension ScenicMapViewController : SpotListViewSelectProtocol {
    func didSelectSpot(spot:String) {
        gotoSpot(scenic)
    }
    func gotoSpot(scenic:Scenic){
        let to_vc = SpotInfoViewController()
        to_vc.scenic = scenic
        navigationController?.pushViewController(to_vc, animated: true)
    }
}

// MARK: - BMKMapViewDelegate
extension ScenicMapViewController : BMKMapViewDelegate {
    /**
     *当选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 选中的annotation views
     */
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        NSLog("选中了标注")
//        gotoSpot(scenic)
        
        //TODO:进入景区
    }
    
    /**
     *当点击annotation view弹出的泡泡时，调用此接口
     *@param mapView 地图View
     *@param view 泡泡所属的annotation view
     */
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        NSLog("点击了泡泡")
        //TODO:进入景区
//        gotoSpot(scenic)
    }
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! SpotAnnoView?
        
        if annotationView == nil {
            annotationView = SpotAnnoView(annotation: annotation, reuseIdentifier: AnnotationViewID)
        }
        annotationView?.setSpotImage(UIImage(named: "icon_postion2")!)
        annotationView?.setSpotName(annotation.title!())
        //annotationView?.annotation = annotation
        return annotationView
    }
}
