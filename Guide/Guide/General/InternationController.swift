
import UIKit
let InternationInstance = InternationController()
class InternationController: NSObject {
    
    var bundle: NSBundle!
    
    func initUserLanguage(){
        let def = UserDefaultInstance
        var language = "zh-Hans"
        
        if let str = def.objectForKey(UserLanguageKey) as? String {
            language = str
        }else {
            if let syslan = NSLocale.preferredLanguages().first {
                if syslan.containsString("en-US"){
                    language = "en"
                }else if syslan.containsString("zh-Hans"){
                    language = "zh-Hans"
                }
            }
            def.setObject(language, forKey: UserLanguageKey)
            def.synchronize()
            //持久化，不加的话不会保存
        }
        //获取文件路径
        if let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj"){
            self.bundle = NSBundle(path: path)//生成bundle
        }
    }
    
    func setUserLanguage(language: String){
        let def = UserDefaultInstance
        //1.第一步改变bundle的值
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        self.bundle = NSBundle(path: path!)//生成bundle
        //2.持久化
        def.setObject(language, forKey: UserLanguageKey)
        def.synchronize() //持久化，不加的话不会保存
    }
}

extension String{
    func internationByKey(key: String) -> String{
        let str = InternationInstance.bundle.localizedStringForKey(key, value: self, table: "Language")
        return str
    }
}
