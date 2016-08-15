
import UIKit

//API...URL...IP
let MainDomain = "http://121.42.166.48:8080/lybl"

//公共返回内容
//code 1成功，0失败
//message 返回信息

//MARK:登录注册模块
//1. 用户登录
/*
 1.phone  - 手机号码
 2.pwd  - 登录密码
 */
let Http_login = "\(MainDomain)/client/userlogin"

//2.发送短信验证码
/*
 1.phone  - 手机号码
 */
let Http_sendsms = "\(MainDomain)/client/sendsms"

//3.验证短信验证码
/*
 1.phone  - 手机号码
 2.code  - 验证码
 3.state - 1注册，2找回密码
 */
let Http_validate = "\(MainDomain)/client/validate"

//4.用户注册
/*
 1.phone  - 手机号码
 2.pwd  - 登录密码
 */
let Http_register = "\(MainDomain)/client/useregister"

//5.用户找回密码
/*
 1.phone  - 手机号码
 2.pwd  - 新密码
 */
let Http_userfindpwd = "\(MainDomain)/client/userfindpwd"

//MARK:用户中心模块
//1.使用反馈
/*
 1.uid  - 登录用户id
 2.msg  - 反馈内容1， 选择问题文字部分
 3.msg2 - 反馈内容2
 4.linkme - 联系方式
 */
let Http_userfeedback = "\(MainDomain)/client/userfeedback"

//2.设置语言
/*
 1.uid  - 登录用户id
 2.language  - 用户设置语言
 */
let Http_usersetlanguage = "\(MainDomain)/client/usersetlanguage"

//3.获取文章内容
/*
 1.type  - 获取文章内容类型，1、关于我们，2、公司概况，3、用户协议，4、QQ交流群
 */
let Http_aboutus = "\(MainDomain)/client/aboutus"

//MARK:景区选择模块
//1.获取省份
let Http_getprovince = "\(MainDomain)/client/getprovince"

//2.获取省份的市
/*
 1.provinceid  - 省份id
 */
let Http_getcity = "\(MainDomain)/client/getcity"

//3.获取当前市的景区
/*
 1.provinceid  - 省份
 2.city  - 市
 3.name  - 名称，模糊搜索，没有可以传空字符串
 */
let Http_searchscenicspot = "\(MainDomain)/client/searchscenicspot"

//4.购买景区资料
/*
 1.uid  - 用户id
 2.scenicspotid  - 景区id
 3.lat  - 当前位置纬度
 4.lng  - 当前位置经度
 */
let Http_buyscenicspot = "\(MainDomain)/client/buyscenicspot"

//5.用户打开景区资料上传位置信息
/*
 1.uid  - 用户id
 2.scenicspotid  - 景区id
 3.lat  - 当前位置纬度
 4.lng  - 当前位置经度
 */
let Http_updateopenscenicspot = "\(MainDomain)/client/updateopenscenicspot"

//6.定位经纬度获取景区信息
/*
 1.lat  - 当前位置纬度
 2.lng  - 当前位置经度
 */
let Http_loascenicspot = "\(MainDomain)/client/loascenicspot"

//7.获取景区的全部景点信息
/*
 1.ssid  - 景区id
 */
let Http_getscenicpoint = "\(MainDomain)/client/getscenicpoint"

//9.获取景区详情
/*
 1.id  - 用户id
 */
let Http_scenicDetail = "\(MainDomain)/client/detail"

//8.下载信息
/*
 1.uid  - 用户id
 2.sid  - 景区id
 3.lat  - 当前位置纬度
 4.lng  - 当前位置经度
 */
let Http_download = "\(MainDomain)/client/download"

//MARK:积分模块
//1.我的积分
/*
 1.uid  - 用户id
 */
let Http_customerinout = "\(MainDomain)/inout/customerinout-t"

//2.充值
/*
 1.uid  - 用户id
 */
let Http_tochongzhi = "\(MainDomain)/inout/tochongzhi-t"















