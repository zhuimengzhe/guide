//
//  SpotModel.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
class SpotModel {
    //景点 id
    var id:String!
    
    //景点 名称 中文 英文 日文 韩文 西班牙文
    var name1:String!
    var name2:String!
    var name3:String!
    var name4:String!
    var name5:String!
    
    //景点 缩略图
    var logo:String!
    
    //景点标志性图片,多个使用,分割
    var img:String!
    
    //景点描述 中文 英文 日文 韩文 西班牙文
    var content1:String!
    var content2:String!
    var content3:String!
    var content4:String!
    var content5:String!
    
    //景点 纬度
    var lat:String!
    
    //景点 经度
    var lng:String!
    
    //景点 语音介绍 中文 英文 日文 韩文 西班牙文
    var sound1:String!
    var sound2:String!
    var sound3:String!
    var sound4:String!
    var sound5:String!
    
    //景点 视频,多个使用,分割
    var video:String!
    
    //添加时间
    var addtime:String!
    
    //所属景区 id
    var ssid:String!
    
    //构造
    init(dict:[String:String]) {
        id = dict["sp_id"] ?? ""
        name1 = dict["sp_name1"] ?? ""
        logo = dict["sp_logo"] ?? ""
        img = dict["sp_img"] ?? ""
        content1 = dict["sp_content1"] ?? ""
        lat = dict["sp_lat"] ?? "0"
        lng = dict["sp_lng"] ?? "0"
        sound1 = dict["sp_sound1"] ?? ""
        video = dict["sp_video"] ?? ""
        addtime = dict["sp_addtime"] ?? ""
        ssid = dict["sp_ssid"] ?? ""
    }
    
}