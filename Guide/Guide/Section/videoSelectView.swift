//
//  videoSelectView.swift
//  Guide
//
//  Created by apple on 4/27/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import UIKit

protocol VideoSelectProtocol {
    func didSelectVideo(video:String)
}

class videoSelectView: UIButton {
    
    var delegate:VideoSelectProtocol?
    
    private let cellH: CGFloat = 40.Fit6()
    static private let margin:CGFloat = 40
    private let cellW: CGFloat = ScreenWidth - videoSelectView.margin
    
    var videos:[String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        addTarget(self, action: #selector(videoSelectView.hideself), forControlEvents: .TouchUpInside)
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
    private let animationDuration = 0.35
    
    private func initFormCell(dataSource:Scenic){
        if dataSource.video.containsString(",") {
            videos = dataSource.video.split(",")
        }else{
            videos = [dataSource.video]
        }
        
        tableView.frame = CGRectMake(videoSelectView.margin / 2, 80.Fit6(), cellW, cellH * 8)
        tableView.setWane(8)
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Color_line
        tableView.separatorStyle = .SingleLine
        tableView.separatorInset = UIEdgeInsetsMake(0,15.Fit6(), 0, 15.Fit6())
        tableView.layoutMargins = tableView.separatorInset
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransformMakeScale(0.001, 0.001)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        addSubview(tableView)
        show()
    }
    
    func show(){
        UIView.animateWithDuration(animationDuration, animations: { [unowned self] () -> Void in
            self.tableView.transform = CGAffineTransformIdentity
            })
    }
    func hideself(){
        hide()
    }
    
    func hide(complete:(() -> Void)? = nil){
        tableView.scaleSmallWithTime(animationDuration) { [unowned self]() -> Void in
            self.removeFromSuperview()
        }
        UIView.animateWithDuration(animationDuration, animations: {
            [unowned self] () -> Void in
            self.backgroundColor = UIColor.clearColor()
            
        }) { (com:Bool) in
            if com {
                if let comple = complete {
                    comple()
                }
            }
        }
    }
}
extension videoSelectView : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellH
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellH
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0,0,cellW,cellH))
        let uilabel = UILabel(frame: CGRectMake(0,0,cellW,cellH - 1))
        uilabel.textAlignment = .Center
        uilabel.backgroundColor = UIColor.whiteColor()
        uilabel.text = "景点选择视频"
        view.addSubview(uilabel)
        
        let line = UILabel(frame: CGRectMake(15.Fit6(),view.frameHeight - 1,cellW - 30.Fit6(),0.5))
        line.backgroundColor = tableView.separatorColor
        
        view.addSubview(line)
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.separatorInset = UIEdgeInsetsMake(0,15.Fit6(), 0, 15.Fit6())
        cell.layoutMargins = tableView.separatorInset
        
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.textLabel?.text = videos[indexPath.row]
        return cell
    }
}
extension videoSelectView : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hide(){
            [unowned self] in
            self.delegate?.didSelectVideo(self.videos[indexPath.row])
        }
    }
}
