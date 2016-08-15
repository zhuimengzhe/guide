//
//  AppDelegate.swift
//  Guide
//
//  Created by dingmc on 15/12/28.
//  Copyright © 2015年 dingmc. All rights reserved.
//

import UIKit
import CoreData

let AppInstance:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var mapManager: BMKMapManager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if !UserDefaultInstance.boolForKey(FirstLaunchKey) {
            UserDefaultInstance.setBool(true, forKey: FirstLaunchKey)
            UserDefaultInstance.setBool(true, forKey: ZiDongJiangJieKey)
            UserDefaultInstance.setBool(true, forKey: XiaoXiTuiSongKey)
            UserDefaultInstance.setBool(true, forKey: ShouTingFangShiKey)
        }
        
        ZipsharedInstance.getFile()
        //注册微信
        WXApi.registerApp(WeChatKey)
        InternationInstance.initUserLanguage()
        //自动登录
        UserInstance.getCurUser()
        
        //百度地图
        mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start(BaiDuMapKey, generalDelegate: self)
        
        if ret == false {
            debugPrint("manager start failed!")
        }
        
        if let remote = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] {
            print("远程通知带动启动 \(remote)")
        }
        //选择了消息推送按钮
        if UserDefaultInstance.boolForKey(XiaoXiTuiSongKey) {
            configUserSetting(launchOptions)
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        let root_vc = MainViewController() //ScenicInfoViewController()
        let nav = BaseNavigationViewController(rootViewController: root_vc)
        self.window!.rootViewController = nav
        return true
    }
    
    func configUserSetting(launchOptions: [NSObject: AnyObject]?){
        JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Badge.rawValue, categories: nil)
        //极光推送
        JPUSHService.setupWithOption(launchOptions, appKey: JPUSHKEY, channel: nil, apsForProduction: false)
        JPUSHService.setLogOFF()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // 远程推送通知 注册失败
    }
    //接收到远程推送
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let notif    = userInfo as NSDictionary
        let apsDic   = notif.objectForKey("aps") as? [String:AnyObject]
        let badgenum = apsDic!["badge"]?.integerValue ?? 1
        application.applicationIconBadgeNumber += badgenum
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        application.applicationIconBadgeNumber = 0
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {}
    
    func applicationDidBecomeActive(application: UIApplication) {}
    
    func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }
    //微信
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Guide", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            //dict[NSUnderlyingErrorKey] = error as？ NSError
            let wrappedError = NSError(domain: "com.hongxing.guide", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
//百度地图
extension AppDelegate : BMKGeneralDelegate{
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }
}
extension AppDelegate : WXApiDelegate {
    func onReq(req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    func onResp(resp: BaseResp!) {
        //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
        if resp.isKindOfClass(SendMessageToWXResp){//确保是对我们分享操作的回调
            print("分享回调:\(resp.errCode)")
            if resp.errCode == WXSuccess.rawValue{
                //分享成功
                AlertInstance.showHud(KeyWindow, str: "分享成功")
            }else{
                //分享失败
                if let error = resp.errStr {
                    AlertInstance.showHud(KeyWindow, str:error)
                }
            }
        }
    }
}