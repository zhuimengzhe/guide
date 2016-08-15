
import UIKit
import CoreData

class Scenic: NSObject {
    var id: String!
    var name: String!
    var summary: String!
    var logo: String!
    var lat: String!
    var lng: String!
    var video:String!
    
    convenience init(dict: NSDictionary) {
        self.init()
        id = dict.getStringByKey("ss_id")
        name = dict.getStringByKey("ss_name1")
        summary = dict.getStringByKey("ss_summary1")
        logo = dict.getStringByKey("ss_logo")
        lat = dict.getIntOrStr("ss_lat")
        lng = dict.getIntOrStr("ss_lng")
        video = ""
    }
    
    convenience init(managerObject: NSManagedObject){
        self.init()
        id = managerObject.valueForKey("id") as? String
        name = managerObject.valueForKey("name") as? String
        summary = managerObject.valueForKey("summary") as? String
        logo = managerObject.valueForKey("logo") as? String
        lat = managerObject.valueForKey("lat") as? String
        lng = managerObject.valueForKey("lng") as? String
        video = ""
    }
    
    override var description: String {
        return "\n{\n\tid = " + id + "\n\tname = " + name + "\n\tsummary = " + summary + "\n\tlogo = " + logo + "\n\tlat = " + lat + "\n\tlng = " + lng + "\n}"
    }
}
