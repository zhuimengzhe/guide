

import UIKit

class Score: NSObject {
    var balance: String!
    var createDate: String!
    var flag: Bool!
    var number: String!
    var remark: String!
    var state: String!
    
    init(dict: NSDictionary) {
        self.balance = dict.getIntOrStr("balance")
        self.createDate = dict.getIntOrStr("createDate")
        self.state = dict.getIntOrStr("state")
        self.number = dict.getIntOrStr("number")
        self.remark = dict.getIntOrStr("remark")
    }
}
