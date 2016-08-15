//
//  CityModel.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
class CityModel {
    //市 id
    var cityid:String!
    //市 所在省份 id
    var provinceid:String!
    //市 名称 中文
    var city1:String!
    //市 名称 英文
    var city2:String!
    //市 名称 日文
    var city3:String!
    //市 名称 韩文
    var city4:String!
    //市 名称 西班牙文
    var city5:String!
    //构造
    init(dict:[String:String]){
        cityid = dict["cityid"] ?? ""
        provinceid = dict["provinceid"] ?? ""
        city1 = dict["city1"] ?? ""
        city2 = dict["city2"] ?? ""
        city3 = dict["city3"] ?? ""
        city4 = dict["city4"] ?? ""
        city5 = dict["city5"] ?? ""
    }
}