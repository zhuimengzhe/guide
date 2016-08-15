
import UIKit

//Color
let Color_topNav = UIColor.colorWithHexCode("41A1BB")

let Color_mainBg = UIColor.colorWithHexCode("f4f4f4")

let Color_222 = UIColor.colorWithHexCode("222")
let Color_333 = UIColor.colorWithHexCode("333")
let Color_666 = UIColor.colorWithHexCode("666")
let Color_999 = UIColor.colorWithHexCode("666")
let Color_ccc = UIColor.colorWithHexCode("ccc")
let Color_eee = UIColor.colorWithHexCode("eee")

let Color_point = UIColor.colorWithHexCode("ff6655")

let Color_progress = UIColor.colorWithHexCode("00ff00")

//Mark: 根据6尺寸适配...

let ScreenWidth = UIScreen.mainScreenWidth
let ScreenHeight = UIScreen.mainScreenHeight

let scaleH6 = UIScreen.mainScreenWidth / 667.0
let scaleW6 = UIScreen.mainScreenWidth / 375.0

let scale6 = (scaleH6 > scaleW6 ? scaleH6 : scaleW6)

let UserDefaultInstance = NSUserDefaults.standardUserDefaults()
let UserDefaultInstanceSync = UserDefaultInstance.synchronize()

let KeyWindow = UIApplication.sharedApplication().keyWindow!

let ZiDongJiangJieKey = "ZiDongJiangJieKeyy"
let ShouTingFangShiKey = "ShouTingFangShiKeyy"
let XiaoXiTuiSongKey = "XiaoXiTuiSongsKeyy"
let FirstLaunchKey = "FirstLaunchappKeyy"
let UserLanguageKey = "userLanguageKeyy"

let BaiDuMapKey = "W2rmU9oCBnaAnntRrb9N63uk"
let WeChatKey = "wx9dcc0cbfbb8d72c0"
let WeChatSecret = "d4624c36b6795d1d99dcf0547af5443d"
let JPUSHKEY = "365f6e4d821c74f1299d2f18"

let DemoAccount = "13233696026"
let DemoPass = "wwwwww"

let AppTest = true