//
//  ConvenienceTools.swift
//  MyMint
//
//  Created by zhoukang on 15/6/1.
//  Copyright (c) 2015年 Oracleen. All rights reserved.
//
import UIKit
//从哪个viewcontroller弹出一个 alert出来
public func alert(controller:UIViewController!, message:String!){
    let alertView = UIAlertController(title: "温馨提示", message: message, preferredStyle: .Alert)
    controller.presentViewController(alertView, animated: true) { () -> Void in
        print("有错误了哦")
    }
}

//打印错误日志 比较全面
public func printLog<T>(message:T,file:String = #file,method:String = #function,line:Int = #line,column:Int = #column){
    debugPrint("\((file as NSString).lastPathComponent)[\(line)行],\(method):\(message)")
}

//包装 多线程 同步方法
func synchronized(lock:AnyObject,closure:()->()){
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

//获取一个随机数
func randomInRange(range:Range<Int>) -> Int{
    let count = UInt32(range.endIndex  - range.startIndex)
    return Int(arc4random_uniform(count)) + range.startIndex
}

//交换两个数
func swapMe<T>(inout a:T,inout b:T){
    (a,b) = (b,a)
}
