//
//  SpotListView.swift
//  Guide
//
//  Created by apple on 4/29/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import UIKit

protocol SpotListViewSelectProtocol {
    func didSelectSpot(video:String)
}

class SpotListView : UIButton {
    
    var delegate:SpotListViewSelectProtocol?
    
    let cellH: CGFloat = 44.Fit6()
    let cellW: CGFloat = 141
    private let anntationDuration = 0.4
    var videos:[String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(SpotListView.hideBtn), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(dbsource:Scenic){
        self.init(frame: UIScreen.mainScreen().bounds)
        initFormCell(dbsource)
    }
    
    private let tableView = UITableView()
    private let cellIdentifier = "videoCell"
    private let hMargin:CGFloat = 8.Fit6()
    
    private func initFormCell(dataSource:Scenic){
        if dataSource.video.containsString(",") {
            videos = dataSource.video.split(",")
        }else{
            videos = [dataSource.video]
        }
        //282 544
        tableView.frame = CGRectMake(ScreenWidth - 141,64, cellW, 0)
        tableView.backgroundColor = backgroundColor
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Color_line
        tableView.separatorStyle = .SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = tableView.separatorInset
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        addSubview(tableView)
        show()
    }
    func show(){
        UIView.animateWithDuration(anntationDuration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .CurveEaseInOut, animations: {
            [unowned self] in
            self.tableView.frame = CGRectMake(ScreenWidth - 141,64, self.cellW, self.cellH * 6)
        }) { (finish:Bool) in
            if finish {
                
            }
        }
    }
    func hideBtn(){
        hide()
    }
    
    func hide(complete:(() -> Void)? = nil){
        UIView.animateWithDuration(anntationDuration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .CurveEaseInOut, animations: {
            [unowned self] in
            self.tableView.frame = CGRectMake(ScreenWidth - 141,64, self.cellW, 0)
        }) { (finish:Bool) in
            if finish {
                self.removeFromSuperview()
                if let com = complete {
                    com()
                }
            }
        }
        
        UIView.animateWithDuration(anntationDuration) { [unowned self] () -> Void in
            self.backgroundColor = UIColor.clearColor()
        }
    }
}
extension SpotListView : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellH
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = tableView.separatorInset
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        cell.textLabel?.text = videos[indexPath.row]
        return cell
    }
}
extension SpotListView : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hide(){
            [unowned self] in
            self.delegate?.didSelectSpot(self.videos[indexPath.row])
        }
    }
}
