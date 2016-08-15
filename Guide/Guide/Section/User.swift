

import UIKit

class User: NSObject, NSCoding{
    var id: String!
    //var logo:String!
    //var phone:String!
    //var pwd:String!
    //var status:String!
    //var language:String!
    //var addtime:String!
    //var point:Double!
    
    var dict: NSDictionary!
    override init(){
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder){//归档反序列化
        if let dict = aDecoder.decodeObjectForKey("userDict") as? NSDictionary{
            self.init(dict: dict)
        }else{
            self.init()
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder){//归档序列化
        aCoder.encodeObject(self.dict, forKey: "userDict")
    }
    
    convenience init(dict: NSDictionary) {
        self.init()
        self.dict = dict
        self.id = dict.getIntOrStr("u_id")
    }
}
