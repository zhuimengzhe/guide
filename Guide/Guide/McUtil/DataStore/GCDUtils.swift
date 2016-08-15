
import UIKit

var GlobalMainQueue : dispatch_queue_t {
    return dispatch_get_main_queue()
}

@available(iOS 8.0, *)
var GlobalUserInteractiveQueue : dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalUserInitiatedQueue : dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalUtilityQueue : dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalBackgroundQueue : dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}

var GlobalQueue : dispatch_queue_t{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
}

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//    //需要长时间处理的代码
//    dispatch_async(dispatch_get_main_queue(), {
//        //需要主线程执行的代码
//    })
//})
