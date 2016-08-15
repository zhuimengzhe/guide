
import UIKit
import CoreData

let CoreDatasharedInstance = CoreDataUtil()
class CoreDataUtil: NSObject {
    //CRUD
    func findAllScenic() -> [Scenic]{
        //1.取得总代理 和托管对象内容总管
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        //2.建立一个获取请求
        let fetchRequest = NSFetchRequest(entityName: "Scenic")
        //3.执行请求
        var friends = [Scenic]()
        
        do {
            let results =  try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            printLog("读取 Scenic 成功...")
            for r in results{
                friends.append(Scenic(managerObject: r))
            }
        } catch {
            printLog("读取失败:...")
        }
        return friends
    }
    
    
    func findById(id: String)-> Scenic!{
        //1.取得总代理 和托管对象内容总管
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        //2.建立一个获取请求
        let fetchRequest = NSFetchRequest(entityName: "Scenic")
        
        //3.执行请求
        let predicate = NSPredicate(format: "id = '\(id)'", argumentArray: nil)//条件查询...
        fetchRequest.predicate = predicate
        var friend: Scenic!
        
        do {
            let results =  try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            printLog("读取成功...")
            for r in results{
                friend = Scenic(managerObject: r)
            }
        } catch {
            printLog("读取失败:...")
        }
        return friend
    }
    
    func saveScenic(object: Scenic){//保存新数据到本地coredata...
        printLog("保存新纪录...")
        //1.取得总代理 和托管对象内容总管
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        //2.建立一个entity
        let entity = NSEntityDescription.entityForName("Scenic", inManagedObjectContext: managedObjectContext)
        let friend = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        //3.保存新的message
        friend.setValue(object.id, forKey: "id")
        friend.setValue(object.name, forKey: "name")
        friend.setValue(object.summary, forKey: "summary")
        friend.setValue(object.logo, forKey: "logo")
        friend.setValue(object.lng, forKey: "lng")
        friend.setValue(object.lat , forKey: "lat")
        
        //4.保存entity到托管对象内容总管中
        do {
            try managedObjectContext.save()
            printLog("保存成功...")
        } catch {
            printLog("保存失败:...")
        }
    }
    
    func deleteWithEntity(id : String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Scenic")
        
        let predicate = NSPredicate(format: "id = '\(id)'", argumentArray: nil)//条件查询...
        fetchRequest.predicate = predicate
        
        do {
            let results =  try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            printLog("读取成功...")
            for r in results{
                managedObjectContext.deleteObject(r)
            }
            try managedObjectContext.save()
        } catch {
            printLog("删除失败:...")
        }
    }
}
