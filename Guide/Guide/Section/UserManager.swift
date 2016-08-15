
import UIKit

let UserInstance = UserManager()
class UserManager: NSObject {
    var user: User!//当前登录用户
    
    let curUserKey = "curUserKey"//归档当前用户信息的key
    
    private let loginKey = "IsLogin"
    private let accountKey = "account"
    private let passwordKey = "password"
    override init() {
        super.init()
        //头像数据源
    }
    
    func setUserByDict(dict: NSDictionary){
        self.user = User(dict: dict)
        self.saveUser()
    }
    
    func saveAccount(account: String, password: String,login:Bool){
        UserDefaultInstance.setBool(login, forKey: loginKey)
        UserDefaultInstance.setObject(account, forKey: accountKey)
        UserDefaultInstance.setObject(password, forKey: passwordKey)
        UserDefaultInstanceSync
    }
    
    func getAccount() -> String?{
        if let account = UserDefaultInstance.valueForKey(accountKey) as? String{
            return account
        }
        return nil
    }
    
    func getPassword() -> String?{
        if let account = UserDefaultInstance.valueForKey(passwordKey) as? String{
            return account
        }
        return nil
    }
    func login() {
        UserDefaultInstance.setBool(true, forKey: loginKey)
        UserDefaultInstanceSync
    }   
    func logout(){
        UserDefaultInstance.setBool(false, forKey: loginKey)
        UserDefaultInstanceSync
    }
    func isLogin() -> Bool {
        if let b = UserDefaultInstance.valueForKey(loginKey) as? Bool {
            return b
        }
        return false
    }
    //存储当前user对象信息
    func saveUser(){
        ObjectStorage.saveByKey(self.curUserKey, object: self.user)
    }
    
    //从归档中拿用户信息
    func getCurUser()->Bool{
        if let u = ObjectStorage.findByKey(self.curUserKey) as? User{
            self.user = u
            return true
        }
        return false
    }
}
